[doc("Setup repo for workspace use with Jujutsu")]
[group("Justfile Repo")]
[no-cd]
setup:
    #!/usr/bin/env -S bash -eu -o pipefail
    _fail() { echo "$1" >&2; exit 1; }
    if test -d ".jj"
    then
        jj git remote rename origin nix
        jj git remote add origin git@github.com:NVIDIA/VisRTX.git
        jj git remote add tarcila git@github.com:tarcila/VisRTX.git
        jj git fetch --all-remotes
        echo '/.gitignore' >> .gitignore
    elif test -d ".git"
    then
        git remote rename origin nix
        git remote add origin
    else
        _fail "This folder is not managed by git nor jujutsu."
    fi

[doc("Create a new workspace tracking a given remote branch")]
[group("Justfile Repo")]
[no-cd]
new_workspace where tracking:
    #!/usr/bin/env -S bash -eu -o pipefail
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
forget_workspace where:
    #!/usr/bin/env -S bash -eu -o pipefail
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