# Some rational for the following
# - We want to expose some possibly custom cmake module so it can be found, possibly transitively by our targets
# - We want a better control on how dependencies are found, hence the disabled registry
# - RPath is on so we don't need to build a fullblown LD_LIBRARY_PATH. Neither a nix nor a full install would require that
# - Try and output the libraries in the lib folder so we don't have to question lib vs lib64 (ubuntu, fedora...)
# - And then make sure some useful default compilation flags are set

[doc("CMake configure, optionally forcing reconfigure if already done")]
[group("Justfile CMake")]
[no-cd]
_cmake_configure force source_dir build_dir install_dir *cmake_options:
    #!/usr/bin/env -S bash -eu -o pipefail
    if test "{{ force }}" -eq "1" -o \! -e "{{ install_dir }}/_cmake/CMakeCache.txt"
    then
        cmake -Wno-dev -G "Ninja Multi-Config" \
            -DCMAKE_FIND_USE_PACKAGE_REGISTRY=OFF \
            -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
            -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
            -DCMAKE_INSTALL_LIBDIR=lib \
            -DCMAKE_CXX_FLAGS_INIT="-Wno-deprecated" \
            -DCMAKE_CXX_FLAGS_DEBUG_INIT="-g3 -fno-omit-frame-pointer" \
            -DCMAKE_CUDA_FLAGS_INIT="-Wno-deprecated-gpu-targets" \
            -DCMAKE_INSTALL_PREFIX="{{ install_dir }}" \
            -DCMAKE_CONFIGURATION_TYPES="Debug;RelWithDebInfo;Release" \
            -DCMAKE_DEFAULT_BUILD_TYPE="RelWithDebInfo" \
            -S "{{ source_dir }}" -B "{{ build_dir }}" \
            {{ cmake_options }}
    fi

[doc("CMake configure")]
[group("Justfile CMake")]
[no-cd]
cmake_configure cfg source_dir build_dir install_dir *cmake_options: (_cmake_configure "0" cfg source_dir build_dir install_dir cmake_options)

[doc("CMake reconfigure")]
[group("Justfile CMake")]
[no-cd]
cmake_force_configure cfg source_dir build_dir install_dir *cmake_options: (_cmake_configure "1" cfg source_dir build_dir install_dir cmake_options)

[doc("CMake build")]
[group("Justfile CMake")]
[no-cd]
cmake_build cfg build_dir target="install":
    cmake --build "{{ build_dir }}" --config "{{ cfg }}" --target "{{ target }}"

[doc("CMake install")]
[group("Justfile CMake")]
[no-cd]
cmake_install cfg build_dir: (cmake_build cfg build_dir "install")
