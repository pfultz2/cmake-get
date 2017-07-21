cmake-get
=========

A cmake module to get dependencies. This module can be used in config mode or in script mode.

Installation
============

The module is just one file 'CMakeGet.cmake' which can be copied into your project and then included. It can also be installed with cmake:

    mkdir build
    cd build
    cmake ..
    cmake --build . --target install

And then it can be used with `find_package(CMakeGet)`.


Config mode
===========

In config mode, this is similiar to cmake's `ExternalProject` with some differences:

* Dependencies are installed during cmake configuration instead of during build. This avoids the need of writing super build projects as cmake's `find_*` commands can be used to find the dependencies all in the same build project.
* Non-cmake build steps can be put in a [recipe](http://cget.readthedocs.io/en/latest/src/recipe.html#structure-of-a-recipe) that can be shared and re-used by many users, instead of rewriting the build steps for every projects.
* A `BUILD_DEPS` variable is provided to enable the installation of dependencies(it defaults to OFF). This allows dependencies to be disabled for when a user wants to use a package manager to install the dependencies, but then can be enabled when the user doesn't want to use a package manager.


To setup with cmake, first list the dependecies in a [requirements.txt file](http://cget.readthedocs.io/en/latest/src/requirements.html) and the add something like this to cmake:

    cmake_get_from(requirements.txt PREFIX ${CMAKE_CURRENT_BINARY_DIR}/deps)
    list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR}/deps)

Also, if recipes are used, its best not to list them in the [requirements.txt file](http://cget.readthedocs.io/en/latest/src/requirements.html). Instead just install them in the cmake itself:

    cmake_get(pfultz2/cget-recipes PREFIX ${CMAKE_CURRENT_BINARY_DIR}/deps)
    cmake_get_from(requirements.txt PREFIX ${CMAKE_CURRENT_BINARY_DIR}/deps)
    list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR}/deps)

Of course, this still has the same weakness as `ExternalProject` as the toolchain is not transitive. 

Script mode
===========

Script mode enables the ability to write a cmake script to install a dependency. This can help with toolchain transitivity as the user can invoke the script with all the same cmake settings. The disadvantage is that the user has an extra step to install dependencies. For example, a script 'dependencies.cmake' like this could be made to install dependencies from a 'requirements.txt':

    #!/usr/bin/env cmake -P

    set(ARGS)
    foreach(i RANGE 4 ${CMAKE_ARGC})
        list(APPEND ARGS ${CMAKE_ARGV${i}})
    endforeach()

    set(_PREFIX ${CMAKE_ARGV3})

    # Make sure this is in the module path
    list(APPEND CMAKE_MODULE_PATH ${CMAKEGET_MODULE_PATH})
    include(CMakeGet)

    get_filename_component(PREFIX ${_PREFIX} ABSOLUTE)
    # Install recipes
    cmake_get(pfultz2/cget-recipes PREFIX ${PREFIX} CMAKE_ARGS ${ARGS})
    cmake_get_from(requirements.txt PREFIX ${PREFIX} CMAKE_ARGS ${ARGS})

So then the user would run this instead:

    ./dependencies.cmake deps/
    mkdir build
    cd build
    cmake -DCMAKE_PREFIX_PATH=../deps/ ..


Reference
=========

cmake_get
---------

    cmake_get(<pkg>
        [PREFIX <prefix>]
        [HASH <hash>]
        [CMAKE_FILE <cmake-file>]
        [CMAKE_ARGS <args>...]
    )

This will install a cmake package. It will run something equivalent to this in order to install the package:

    mkdir build
    cd build
    cmake .. -DCMAKE_PREFIX_PATH=${PREFIX} -DCMAKE_INSTALL_PREFIX=${PREFIX} ${CMAKE_ARGS}
    cmake --build .
    cmake --build . --target install

* `<pkg>`<br>
This is the package to be installed as described [here](http://cget.readthedocs.io/en/latest/src/package_src.html). It can be a URL or even a [recipe](http://cget.readthedocs.io/en/latest/src/recipe.html).
* `PREFIX <prefix>`<br>
This is prefix to where the package will be installed.
* `HASH <hash>`<br>
This is a checksum hash that will be checked on a package.
* `CMAKE_FILE <cmake-file>`<br>
This is a cmake file that will be used to build the package. This is useful for a package that does not provide a cmake file already.
* `CMAKE_ARGS <args>...`<br>
This is additional cmake arguments that are passed to the configuration step.

cmake_get_from
--------------

    cmake_get_from(<filename>
        [PREFIX <prefix>]
        [CMAKE_ARGS <args>...]
    )

This will install a list of packages stored in a file.

* `<filename>`<br>
This a file that will list packages to be installed, The format of the file is described [here](http://cget.readthedocs.io/en/latest/src/requirements.html).
* `PREFIX <prefix>`<br>
This is prefix to where the package will be installed.
* `CMAKE_ARGS <args>...`<br>
This is additional cmake arguments that are passed to the configuration step.
