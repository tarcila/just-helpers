# Some rational for the following
# - We want to expose some possibly custom cmake module so it can be found, possibly transitively by our targets
# - We want a better control on how dependencies are found, hence the disabled registry
# - RPath is on so we don't need to build a fullblown LD_LIBRARY_PATH. Neither a nix nor a full install would require that
# - Try and output the libraries in the lib folder so we don't have to question lib vs lib64 (ubuntu, fedora...)
# - And then make sure some useful default compilation flags are set

[doc("CMake configure, optionally forcing reconfigure if already done")]
[group("Justfile CMake")]
[no-cd]
[script("bash", "-euo", "pipefail")]
_configure force source_dir build_dir install_dir *cmake_options:
    if [ "{{ force }}" = "1" ] || [ "{{ path_exists(install_dir / '_cmake/CMakeCache.txt') }}" != "true" ]
    then
        cmake -Wno-author -G "Ninja Multi-Config" \
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
configure source_dir build_dir install_dir *cmake_options: (_configure "0" source_dir build_dir install_dir cmake_options)

[doc("CMake reconfigure")]
[group("Justfile CMake")]
[no-cd]
force_configure source_dir build_dir install_dir *cmake_options: (_configure "1" source_dir build_dir install_dir cmake_options)

[doc("CMake build")]
[group("Justfile CMake")]
[no-cd]
build cfg build_dir target="all":
    cmake --build "{{ build_dir }}" --config "{{ cfg }}" --target "{{ target }}"

[doc("CMake install")]
[group("Justfile CMake")]
[no-cd]
install cfg build_dir: (build cfg build_dir "install")
