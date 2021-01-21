include(ExternalProject)

function(BuildFBEnvironment FB_install_prefix)
    message("------------------------------------------------------------")
    message("Building and installing FB libraries to ${FB_install_prefix}")
    message("Build type: ${CMAKE_BUILD_TYPE}")
    set(COMMON_CMAKE_ARGS -DCMAKE_PREFIX_PATH=${FB_install_prefix} -DCMAKE_INSTALL_PREFIX=${FB_install_prefix} -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE})

    if (${CMAKE_SYSTEM_NAME} STREQUAL Darwin)
    set(BOOST_CLANG_PROJECT_CONFIG ${FB_install_prefix}/clang_project.config)
        file(WRITE ${BOOST_CLANG_PROJECT_CONFIG} "using clang : : /usr/local/opt/llvm/bin/clang++ ;")
        set(BOOST_USER_CONFIG --user-config=${BOOST_CLANG_PROJECT_CONFIG})
    endif()
    set(BOOST_BUILD_FLAGS
        link=static
        runtime-link=shared
        variant=release
        threading=multi
        debug-symbols=on
        visibility=global
        -j4
        ${BOOST_USER_CONFIG}
        install
    )
    set(BOOST_WITH_LIBRARIES context,filesystem,program_options,regex,system,thread)
    message("Boost build flags: ${BOOST_USER_CONFIG}")
    message("Boost libraries built: ${BOOST_WITH_LIBRARIES}")
    ExternalProject_add(boost
        URL         https://versaweb.dl.sourceforge.net/project/boost/boost/1.69.0/boost_1_69_0.tar.bz2
        URL_HASH    SHA256=8f32d4617390d1c2d16f26a27ab60d97807b35440d45891fa340fc2648b04406
        CONFIGURE_COMMAND ./bootstrap.sh --prefix=${DEPS} --with-libraries=${BOOST_WITH_LIBRARIES}
        BUILD_COMMAND ./b2 ${BOOST_BUILD_FLAGS} 
        BUILD_IN_SOURCE true
    )

    ExternalProject_add(double-conversion
        URL		    https://github.com/google/double-conversion/archive/v3.1.4.tar.gz
        URL_HASH	SHA256=95004b65e43fefc6100f337a25da27bb99b9ef8d4071a36a33b5e83eb1f82021
        PREFIX	    ${FB_install_prefix}
        CMAKE_ARGS	${COMMON_CMAKE_ARGS}
    )

    ExternalProject_Add(glog
        URL		    https://github.com/google/glog/archive/v0.4.0.tar.gz
        URL_HASH	SHA256=f28359aeba12f30d73d9e4711ef356dc842886968112162bc73002645139c39c
        PREFIX	    ${FB_install_prefix}
        CMAKE_ARGS	${COMMON_CMAKE_ARGS} -DBUILD_SHARED_LIBS=OFF
    )

    ExternalProject_Add(gflags
        URL		    https://github.com/gflags/gflags/archive/v2.2.2.tar.gz
        URL_HASH	SHA256=34af2f15cf7367513b352bdcd2493ab14ce43692d2dcd9dfc499492966c64dcf
        PREFIX	    ${FB_install_prefix}
        CMAKE_ARGS	${COMMON_CMAKE_ARGS} -DBUILD_STATIC_LIBS=ON -DBUILD_gflags_LIB=ON
    )

    ExternalProject_Add(googletest
        URL         https://github.com/google/googletest/archive/release-1.8.1.tar.gz
        URL_HASH    SHA256=9bf1fe5182a604b4135edc1a425ae356c9ad15e9b23f9f12a02e80184c3a249c
        PREFIX      ${FB_install_prefix}
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DBUILD_SHARED_LIBS=ON -Dgtest_force_shared_crt=ON
    )

    ExternalProject_Add(snappy
        URL		    https://github.com/google/snappy/archive/1.1.7.tar.gz
        PREFIX	    ${FB_install_prefix}
        URL_HASH	SHA256=3dfa02e873ff51a11ee02b9ca391807f0c8ea0529a4924afa645fbf97163f9d4
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=${FB_install_prefix} -DSNAPPY_BUILD_TESTS=OFF  
    )

    ExternalProject_Add(zstd
        URL		    https://github.com/facebook/zstd/releases/download/v1.4.8/zstd-1.4.8.tar.gz
        PREFIX	    ${FB_install_prefix}
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DOPENSSL_ROOT_DIR=/usr/local/Cellar/openssl@1.1/1.1.1g-DZSTD_BUILD_SHARED=OFF
        SOURCE_SUBDIR build/cmake
    )

    ExternalProject_Add(fb_folly
        URL         https://github.com/facebook/folly/releases/download/v2021.01.11.00/folly-v2021.01.11.00.tar.gz
        PREFIX      ${FB_install_prefix}
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DBUILD_TESTS=OFF -DUSE_STATIC_DEPS_ON_UNIX=ON
    )

    ExternalProject_Add(fmt
        URL		    https://github.com/fmtlib/fmt/archive/5.3.0.tar.gz
        URL_HASH	SHA256=defa24a9af4c622a7134076602070b45721a43c51598c8456ec6f2c4dbb51c89
        PREFIX	    ${FB_install_prefix}
        CMAKE_ARGS	${COMMON_CMAKE_ARGS} -DFMT_TEST=OFF -DFMT_DOC=OFF
    )

    ExternalProject_Add(sodium
        URL		    https://github.com/jedisct1/libsodium/releases/download/1.0.17/libsodium-1.0.17.tar.gz
        URL_HASH	SHA256=0cc3dae33e642cc187b5ceb467e0ad0e1b51dcba577de1190e9ffa17766ac2b1
        PREFIX	    ${FB_install_prefix}
        CONFIGURE_COMMAND ./configure --prefix=${FB_install_prefix} --disable-shared
        UPDATE_COMMAND    ""
        BUILD_COMMAND     make
        BUILD_IN_SOURCE   true
        INSTALL_COMMAND   make install
    )

    ExternalProject_Add(openssl
        URL         https://www.openssl.org/source/openssl-1.1.1b.tar.gz
        URL_HASH    SHA256=5c557b023230413dfb0756f3137a13e6d726838ccd1430888ad15bfb2b43ea4b
        PREFIX      ${FB_install_prefix}
        CONFIGURE_COMMAND ./config no-shared no-tests --prefix=${FB_install_prefix} --openssldir=${FB_install_prefix} ${LibCryptoDebug}
        BUILD_COMMAND     make
        BUILD_IN_SOURCE   true
        INSTALL_COMMAND   make install_sw
    )

    ExternalProject_Add(libevent
        URL		    https://github.com/libevent/libevent/archive/release-2.1.8-stable.tar.gz
        URL_HASH	SHA256=316ddb401745ac5d222d7c529ef1eada12f58f6376a66c1118eee803cb70f83d
        PREFIX      ${FB_install_prefix}
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DEVENT__DISABLE_TESTS=ON -DEVENT__DISABLE_BENCHMARK=ON -DEVENT__DISABLE_SAMPLES=ON -DEVENT__DISABLE_REGRESS=ON -DCMAKE_INSTALL_PREFIX=${FB_install_prefix}
        DEPENDS openssl
    )

    ExternalProject_Add(fb_fizz
        URL         https://github.com/facebookincubator/fizz/releases/download/v2021.01.18.00/fizz-v2021.01.18.00.tar.gz
        # URL_HASH    
        PREFIX      ${FB_install_prefix}
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF
        SOURCE_SUBDIR fizz
    )

    ExternalProject_Add(fb_wangle
        URL         https://github.com/facebook/wangle/releases/download/v2021.01.18.00/wangle-v2021.01.18.00.tar.gz
        # URL_HASH
        SOURCE_SUBDIR   wangle
        PREFIX      ${FB_install_prefix}
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF
    )

    ExternalProject_Add(fb_thrift
        URL         https://github.com/facebook/fbthrift/archive/v2021.01.11.00.tar.gz
        PREFIX      ${FB_install_prefix}
        CMAKE_ARGS  ${COMMON_CMAKE_ARGS} -DBUILD_EXAMPLES=OFF -DBUILD_TESTS=OFF
    )

    # TODO: move deps into ExternalProject declaration
    add_dependencies(fb_folly boost glog gflags double-conversion zstd snappy fmt sodium libevent openssl) 
    add_dependencies(fb_fizz fb_folly sodium googletest libevent double-conversion)
    add_dependencies(fb_wangle fb_folly fb_fizz googletest)
    add_dependencies(fb_thrift fb_wangle fb_folly fb_fizz googletest)

    # TODO: split per librariry
    set(FB_Libraries
        libfolly.a 
        libwangle.a 
        libfizz.a
        libglog.a 
        libgflags.a 
        libdouble-conversion.a 
        libevent_core.a 
        libboost_context.a 
        PARENT_SCOPE)
endfunction()
