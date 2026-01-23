# Default wrappers for library recipes with sensible defaults
# This file provides convenient defaults for common use cases.
# For more control, import the library recipes as modules instead.

mod dirs '../dirs'
mod cmake '../cmake'
mod dotfiles '../dotfiles'
mod repo '../repo'

# CMake wrappers with defaults

[doc("CMake configure with defaults (RelWithDebInfo, source=., build=build, install=install)")]
[group("Defaults CMake")]
[working-directory: dirs::_ROOT_DIR]
configure cfg="RelWithDebInfo" source_dir="." build_dir="build" install_dir="install" *cmake_options: (cmake::configure "{{ cfg }}" "{{ source_dir }}" "{{ build_dir }}" "{{ install_dir }}" {{ cmake_options }})

[doc("CMake build with defaults (RelWithDebInfo, build=build)")]
[group("Defaults CMake")]
[working-directory: dirs::_ROOT_DIR]
build cfg="RelWithDebInfo" build_dir="build" target="all": (cmake::build "{{ cfg }}" "{{ build_dir }}" "{{ target }}")

[doc("CMake install with defaults (RelWithDebInfo, build=build)")]
[group("Defaults CMake")]
[working-directory: dirs::_ROOT_DIR]
install cfg="RelWithDebInfo" build_dir="build": (cmake::install "{{ cfg }}" "{{ build_dir }}")

# Dotfiles wrappers with defaults

[doc("Generate .envrc with defaults (source=., install=install)")]
[group("Defaults DotFiles")]
[working-directory: dirs::_ROOT_DIR]
generate_dot_envrc source_dir="." install_dir="install" *additional_envrc_content: (dotfiles::generate_dot_envrc "{{ source_dir }}" "{{ install_dir }}" {{ additional_envrc_content }})

[doc("Generate .clangd with defaults (clangd_dir=., compile_commands_dir=build)")]
[group("Defaults DotFiles")]
[working-directory: _ROOT_DIR]
clangd clangd_dir="." compile_commands_dir="build":
    just generate_dot_clangd "{{ clangd_dir }}" "{{ compile_commands_dir }}"

[doc("Generate .vscode/tasks.json with defaults (vscode_dir=.vscode)")]
[group("Defaults DotFiles")]
[working-directory: _ROOT_DIR]
vscode_tasks vscode_dir=".vscode":
    just generate_vscode_tasks_json "{{ vscode_dir }}"

[doc("Generate .vscode/launch.json with defaults (vscode_dir=.vscode)")]
[group("Defaults DotFiles")]
[working-directory: _ROOT_DIR]
vscode_launch vscode_dir=".vscode":
    just generate_vscode_launch_json "{{ vscode_dir }}"

# Repo wrappers

[doc("Setup repo for workspace use")]
[group("Defaults Repo")]
[working-directory: _ROOT_DIR]
setup:
    just setup

[doc("Create a new workspace tracking a given remote branch")]
[group("Defaults Repo")]
[working-directory: _ROOT_DIR]
workspace where tracking:
    just new_workspace "{{ where }}" "{{ tracking }}"

[doc("Forget a workspace")]
[group("Defaults Repo")]
[working-directory: _ROOT_DIR]
forget where:
    just forget_workspace "{{ where }}"
