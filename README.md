cmake-get
=========

A cmake module to get dependencies. This module can be use in config mode or in script mode.

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
This is a cmake file that will be used to build the package. This is useful fs the package does not provide a cmake file already.
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
