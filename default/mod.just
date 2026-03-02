# Default wrappers for library recipes with sensible defaults
# This file provides convenient defaults for common use cases.
# For more control, import the library recipes as modules instead.

mod cmake '../cmake'
mod dotfiles '../dotfiles'
mod repo '../repo'

import '../dirs/mod.just'

cfg := env("cfg", "RelWithDebInfo")

_source_dir := _ROOT_DIR
_root_dir := _ROOT_DIR
_build_dir := _root_dir / "_out/_cmake"
_install_dir := _root_dir / "_out"
_envrc_dir := _root_dir
_clangd_dir := _root_dir
_compile_commands_dir := _build_dir
_compiler := if os() == "macos" { "clang++" } else { "g++" }
_vscode_dir := _root_dir / ".vscode"
_emacs_desktop_dir := _root_dir / ".emacs.d"
_dape_dir := _root_dir

# CMake wrappers with defaults

[doc("Configure")]
configure *cmake_options: (cmake::force_configure _source_dir _build_dir _install_dir cmake_options)

[doc("Reconfigure")]
reconfigure: (cmake::configure _source_dir _build_dir _install_dir)

[doc("Build")]
[metadata("task", "pm=$gcc")]
build cfg=cfg: reconfigure (cmake::install cfg _build_dir)

[doc("Rebuild")]
[metadata("task", "pm=$gcc")]
rebuild cfg=cfg: clean (build cfg)

[doc("Remove the installation dir")]
clean:
    rm -fr "{{ _install_dir }}"

# Auxiliary recipes

[doc("Generate .envrc file")]
generate_envrc: (dotfiles::generate_envrc _envrc_dir _install_dir)

[doc("Generate .clangd config file")]
generate_clangd compiler=_compiler: (dotfiles::generate_clangd _clangd_dir _compile_commands_dir compiler)

[doc("Generate .vscode/tasks.json")]
generate_vscode_tasks_json: (dotfiles::generate_vscode_tasks_json _vscode_dir)

[doc("Generate .vscode/launch.json")]
generate_vscode_launch_json: (dotfiles::generate_vscode_launch_json _vscode_dir)

[doc("Generate .emacs.desktop file")]
generate_emacs_desktop: (dotfiles::generate_emacs_desktop _emacs_desktop_dir)

[doc("Generate .dape.el with defaults")]
generate_emacs_dape: (dotfiles::generate_emacs_dape "{{ dape_dir }}")

# Repo wrappers

[doc("Setup repo for workspace use")]
setup:
    just setup

[doc("Create a new workspace tracking a given remote branch")]
workspace where tracking:
    just new_workspace "{{ where }}" "{{ tracking }}"

[doc("Forget a workspace")]
forget where:
    just forget_workspace "{{ where }}"
