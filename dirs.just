# Try and get the closest jujutsu or git folder.
# Equivalent to `git rev-parse --show-toplevel` but we don't want to spawn a new process.

# Safety check. Our directory layout expects Invocation and Justfile directories to be different
# so root files are not erased by just commands.
_invocation_directory_is_not_justfile_dir := if invocation_directory() != justfile_directory() { "OK:invocation_directory_is_not_justfile_directory" } else { error("Justfile must NOT be invoked from the root directory of the repository") }

_root_regex := '^(/|[a-zA-Z]:[/\\])$'

_test_ok_1 := if "/" =~ _root_regex { "" } else { error("Does not match") }
_test_ok_2 := if "c:/" =~ _root_regex { "" } else { error("Does not match") }
_test_ok_3 := if "C:/" =~ _root_regex { "" } else { error("Does not match") }
_test_ok_4 := if "c:\\" =~ _root_regex { "" } else { error("Does not match") }
_test_ok_5 := if "C:\\" =~ _root_regex { "" } else { error("Does not match") }

_test_ok_6 := if "prefix/" =~ _root_regex { error("Do not match") } else { "" }
_test_ok_7 := if "/postfix" =~ _root_regex { error("Do not match") } else { "" }
_test_ok_8 := if "C:/postfix" =~ _root_regex { error("Do not match") } else { "" }
_test_ok_9 := if "c:\\postfix" =~ _root_regex { error("Do not match") } else { "" }
_test_ok_A := if "notadrive:\\" =~ _root_regex { error("Do not match") } else { "" }

_git_dir_0 := invocation_directory()
_git_dir_1 := if path_exists(join(_git_dir_0, ".git")) == "true" { _git_dir_0 } else { if _git_dir_0 =~ _root_regex { _git_dir_0 } else { parent_directory(_git_dir_0) } }
_git_dir_2 := if path_exists(join(_git_dir_1, ".git")) == "true" { _git_dir_1 } else { if _git_dir_1 =~ _root_regex { _git_dir_1 } else { parent_directory(_git_dir_1) } }
_git_dir_3 := if path_exists(join(_git_dir_2, ".git")) == "true" { _git_dir_2 } else { if _git_dir_2 =~ _root_regex { _git_dir_2 } else { parent_directory(_git_dir_2) } }
_git_dir_4 := if path_exists(join(_git_dir_3, ".git")) == "true" { _git_dir_3 } else { if _git_dir_3 =~ _root_regex { _git_dir_3 } else { parent_directory(_git_dir_3) } }
_git_dir_5 := if path_exists(join(_git_dir_4, ".git")) == "true" { _git_dir_4 } else { if _git_dir_4 =~ _root_regex { _git_dir_4 } else { parent_directory(_git_dir_4) } }
_git_dir_6 := if path_exists(join(_git_dir_5, ".git")) == "true" { _git_dir_5 } else { if _git_dir_5 =~ _root_regex { _git_dir_5 } else { parent_directory(_git_dir_5) } }
_git_dir_7 := if path_exists(join(_git_dir_6, ".git")) == "true" { _git_dir_6 } else { if _git_dir_6 =~ _root_regex { _git_dir_6 } else { parent_directory(_git_dir_6) } }
_git_dir_8 := if path_exists(join(_git_dir_7, ".git")) == "true" { _git_dir_7 } else { if _git_dir_7 =~ _root_regex { _git_dir_7 } else { parent_directory(_git_dir_7) } }
_git_dir_9 := if path_exists(join(_git_dir_8, ".git")) == "true" { _git_dir_8 } else { if _git_dir_8 =~ _root_regex { _git_dir_8 } else { parent_directory(_git_dir_8) } }

# Same with jujutsu
_jj_dir_0 := invocation_directory()
_jj_dir_1 := if path_exists(join(_jj_dir_0, ".jj")) == "true" { _jj_dir_0 } else { if _jj_dir_0 =~ _root_regex { _jj_dir_0 } else { parent_directory(_jj_dir_0) } }
_jj_dir_2 := if path_exists(join(_jj_dir_1, ".jj")) == "true" { _jj_dir_1 } else { if _jj_dir_1 =~ _root_regex { _jj_dir_1 } else { parent_directory(_jj_dir_1) } }
_jj_dir_3 := if path_exists(join(_jj_dir_2, ".jj")) == "true" { _jj_dir_2 } else { if _jj_dir_2 =~ _root_regex { _jj_dir_2 } else { parent_directory(_jj_dir_2) } }
_jj_dir_4 := if path_exists(join(_jj_dir_3, ".jj")) == "true" { _jj_dir_3 } else { if _jj_dir_3 =~ _root_regex { _jj_dir_3 } else { parent_directory(_jj_dir_3) } }
_jj_dir_5 := if path_exists(join(_jj_dir_4, ".jj")) == "true" { _jj_dir_4 } else { if _jj_dir_4 =~ _root_regex { _jj_dir_4 } else { parent_directory(_jj_dir_4) } }
_jj_dir_6 := if path_exists(join(_jj_dir_5, ".jj")) == "true" { _jj_dir_5 } else { if _jj_dir_5 =~ _root_regex { _jj_dir_5 } else { parent_directory(_jj_dir_5) } }
_jj_dir_7 := if path_exists(join(_jj_dir_6, ".jj")) == "true" { _jj_dir_6 } else { if _jj_dir_6 =~ _root_regex { _jj_dir_6 } else { parent_directory(_jj_dir_6) } }
_jj_dir_8 := if path_exists(join(_jj_dir_7, ".jj")) == "true" { _jj_dir_7 } else { if _jj_dir_7 =~ _root_regex { _jj_dir_7 } else { parent_directory(_jj_dir_7) } }
_jj_dir_9 := if path_exists(join(_jj_dir_8, ".jj")) == "true" { _jj_dir_8 } else { if _jj_dir_8 =~ _root_regex { _jj_dir_8 } else { parent_directory(_jj_dir_8) } }

# Get the longest path of both, check if _git_dir_9 is a prefix of _jj_dir_9
# if _git_dir is not a prefix of _jj_dir, it is longer
_jjgit_dir := if trim_start_match(_jj_dir_9, _git_dir_9) == _jj_dir_9 {
    _git_dir_9
} else {
    _jj_dir_9   
}

_ROOT_DIR := if path_exists(join(_jjgit_dir, ".jj")) == "true" {
    _jjgit_dir
} else {
    if path_exists(join(_jjgit_dir, ".git")) == "true" {
        _jjgit_dir
    } else {
        error("Could not find root dir. Looked up 9 levels above.")
    }
}
