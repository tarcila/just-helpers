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