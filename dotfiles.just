[doc("Generate .envrc config file")]
[group("Justfile DotFiles")]
[no-cd]
generate_dot_envrc source_dir install_dir *additional_envrc_content:
    #!/usr/bin/env -S bash -eu -o pipefail
    DOT_ENVRC="{{ source_dir / ".envrc" }}"
    DOT_ENVRC_TMP="{{ source_dir / ".envrc.tmp" }}"
    cat <<EOT > "${DOT_ENVRC_TMP}"
    source_up

    # Paths to the installed project
    export PATH="{{ install_dir }}/bin\${PATH:+:\${PATH}}"
    export LD_LIBRARY_PATH="{{ install_dir }}/lib\${LD_LIBRARY_PATH:+:\${LD_LIBRARY_PATH}}"
    export DYLD_LIBRARY_PATH="{{ install_dir }}/lib\${DYLD_LIBRARY_PATH:+:\${DYLD_LIBRARY_PATH}}"
    {{ additional_envrc_content }}
    # Local environment overrides
    dotenv_if_exists
    EOT
    cmp -s "${DOT_ENVRC}" "${DOT_ENVRC_TMP}" && rm -f "${DOT_ENVRC_TMP}" || mv -f "${DOT_ENVRC_TMP}" "${DOT_ENVRC}"

[doc("Generate .clangd config file")]
[group("Justfile DotFiles")]
[no-cd]
generate_dot_clangd clangd_dir compile_commands_dir:
    #!/usr/bin/env -S bash -eu -o pipefail

    DOT_CLANGD="{{ clangd_dir / ".clangd" }}"
    DOT_CLANGD_TMP="{{ clangd_dir / ".clangd.tmp" }}"
    echo -e "CompileFlags:\n  CompilationDatabase: {{ compile_commands_dir }}" > "${DOT_CLANGD_TMP}"
    echo -e '  Add:' >> "${DOT_CLANGD_TMP}"
    (
        GCC_OUTPUT=$(g++ -v -E -x c++ - < /dev/null 2>&1)

        # Extract quote include paths (paths after '#include "..." search starts here:')
        QUOTE_SECTION=false
        while IFS= read -r line; do
            if [[ "$line" == '#include "..." search starts here:' ]]; then
                QUOTE_SECTION=true
                continue
            fi
            
            if [[ "$QUOTE_SECTION" == true ]]; then
                # Check if line starts with a space (indented path)
                if [[ "$line" =~ ^\ .+ ]]; then
                    # Remove leading space and print
                    echo "    - -I"
                    echo "    - ${line# }"
                else
                    # Non-indented line means end of section
                    QUOTE_SECTION=false
                fi
            fi
        done <<< "$GCC_OUTPUT"

        # Extract bracket include paths (paths after '#include <...> search starts here:')
        BRACKET_SECTION=false
        while IFS= read -r line; do
            if [[ "$line" == '#include <...> search starts here:' ]]; then
                BRACKET_SECTION=true
                continue
            fi
            
            if [[ "$BRACKET_SECTION" == true ]]; then
                # Check if line starts with a space (indented path)
                if [[ "$line" =~ ^\ .+ ]]; then
                    # Remove leading space and print
                    echo "    - -isystem"
                    echo "    - ${line# }"
                else
                    # Non-indented line means end of section
                    break
                fi
            fi
        done <<< "$GCC_OUTPUT"
    ) >> ${DOT_CLANGD_TMP}
    cmp -s "${DOT_CLANGD}" "${DOT_CLANGD_TMP}" && rm -f "${DOT_CLANGD_TMP}" || mv -f "${DOT_CLANGD_TMP}" "${DOT_CLANGD}"

[doc("Generate .vscode/tasks.json")]
[group("Justfile DotFiles")]
[no-cd]
generate_vscode_tasks_json vscode_dir:
    #!/usr/bin/env -S bash -eu -o pipefail
    mkdir -p "{{ vscode_dir }}"
    just --dump-format json --dump | \
        jq --arg just "{{ just_executable() }}" --slurpfile debuggers "{{ source_directory() }}/filters/_config_{{ os() }}.jq" -M -f "{{ source_directory() }}/filters/code.tasks.jq" > "{{ vscode_dir }}/tasks.json"

[doc("Generate .vscode/launch.json")]
[group("Justfile DotFiles")]
[no-cd]
generate_vscode_launch_json vscode_dir:
    #!/usr/bin/env -S bash -eu -o pipefail
    mkdir -p "{{ vscode_dir }}"
    just --dump-format json --dump | \
        jq --arg just "{{ just_executable() }}" --slurpfile config "{{ source_directory() }}/filters/_config_{{ os() }}.jq" -M -f "{{ source_directory() }}/filters/code.launch.jq" > "{{ vscode_dir }}/launch.json"

[doc("Generate .emacs.desktop file")]
[group("Justfile DotFiles")]
[no-cd]
generate_emacs_desktop emacs_desktop_dir:
    #!/usr/bin/env -S bash -eu -o pipefail
    mkdir -p "{{ emacs_desktop_dir }}"
    DOT_EMACS_DESKTOP="{{ emacs_desktop_dir / ".emacs.desktop" }}"
    DOT_EMACS_DESKTOP_TMP="{{ emacs_desktop_dir / ".emacs.desktop.tmp" }}"
    cat <<EOT > "${DOT_EMACS_DESKTOP_TMP}"
    EOT
    cmp -s "${DOT_EMACS_DESKTOP}" "${DOT_EMACS_DESKTOP_TMP}" && rm -f "${DOT_EMACS_DESKTOP_TMP}" || mv -f "${DOT_EMACS_DESKTOP_TMP}" "${DOT_EMACS_DESKTOP}"
