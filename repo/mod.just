[doc("Create a new workspace tracking a given remote branch")]
[group("Justfile Repo")]
[no-cd]
[script("bash", "-euo", "pipefail")]
new_workspace where tracking:
    _fail() { echo "$1" >&2; exit 1; }
    if test -d ".jj"
    then
        echo '/{{ where }}/' >> .gitignore
        jj workspace add "{{ where }}" -r "{{ tracking }}"
    elif test -d ".git"
    then
        git worktree add -b "{{ where }}" "{{ where }}" "{{ tracking }}"
    fi

[doc("Sync git submodules with jj workspace")]
[group("Justfile Repo")]
[no-cd]
[script('bash', '-xeu', '-o', 'pipefail')]
submodule:
    set -x
    jj git export
    wsroot="$(jj workspace root)"
    jjrepo="$wsroot/.jj/repo"
    if [ -f "$jjrepo" ]; then
      jjrepo="$(cat "$jjrepo")"
      if [[ $jjrepo = /* ]]; then
        jjrepo="$(realpath -m -- "$jjrepo")"
      else
        jjrepo="$(realpath -m -- "$wsroot/.jj/$jjrepo")"
      fi
    fi
    git_target="$(cat "$jjrepo/store/git_target")"
    git_dir="$(realpath -m -- "$jjrepo/store/$git_target")"
    jj_commit="$(jj log -r @ --no-graph -T 'commit_id ++ "\n"')"

    # Never move real HEAD/index here. When the root checkout is colocated,
    # its .git (and HEAD/index) is shared by every jj workspace, so a plain
    # `git checkout` would move the ROOT workspace's history to whatever
    # commit *this* (possibly non-root) workspace happens to be at. Build
    # the submodule checkout against a scratch index instead.
    idx="$(mktemp)"
    trap 'rm -f "$idx"' EXIT
    export GIT_INDEX_FILE="$idx"
    GIT_DIR="$git_dir" GIT_WORK_TREE="$wsroot" \
      git read-tree "$jj_commit"
    GIT_DIR="$git_dir" GIT_WORK_TREE="$wsroot" \
      git checkout-index -a -f

    # A submodule's own .git pointer file records a gitdir path relative to
    # whichever git_target (colocated vs internal store) was active when it
    # was cloned. Toggling colocation later leaves that pointer dangling, so
    # `submodule update` can't resolve the submodule's current revision.
    # Drop any dangling pointer here so it gets re-cloned instead of failing.
    while IFS= read -r -d '' gitfile; do
      gitdir_line="$(cat "$gitfile")"
      case "$gitdir_line" in
        gitdir:*)
          target="${gitdir_line#gitdir: }"
          resolved="$(realpath -m -- "$(dirname "$gitfile")/$target")"
          [ -e "$resolved" ] || rm -f "$gitfile"
          ;;
      esac
    done < <(find "$wsroot" -mindepth 2 -name .git -type f -not -path '*/.jj/*' -print0)

    GIT_DIR="$git_dir" GIT_WORK_TREE="$wsroot" \
      git submodule update --init --recursive --force

[doc("Forget a workspace")]
[group("Justfile Repo")]
[no-cd]
[confirm("Are you sure you want to forget the workspace at '{{ where }}'? This WILL DELETE the folder, not just remove it from the list of workspaces.")]
[script("bash", "-euo", "pipefail")]
forget_workspace where:
    _fail() { echo "$1" >&2; exit 1; }    
    if test -d ".jj"
    then
        jj workspace forget "{{ where }}"
        sed -i '/{{ where }}/d' .gitignore
    elif test -d ".git"
    then
        git worktree remove "{{ where }}"
    else
        _fail "This folder is not managed by git nor jujutsu."
    fi
