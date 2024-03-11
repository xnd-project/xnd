
# ==============================================================================
#                            Clear all relevant flags
# ==============================================================================

macro(clear_flags)
  set(CMAKE_C_FLAGS_INIT "" CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_DEBUG_INIT CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_MINSIZEREL_INIT CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_RELEASE_INIT CACHE STRING "" FORCE)

  set(CMAKE_CXX_FLAGS_INIT CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_DEBUG_INIT CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_RELEASE_INIT CACHE STRING "" FORCE)

  set(CMAKE_CUDA_FLAGS_INIT CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_DEBUG_INIT CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_RELWITHDEBINFO_INIT CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_MINSIZEREL_INIT CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_RELEASE_INIT CACHE STRING "" FORCE)


  set(CMAKE_C_FLAGS CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_DEBUG CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_RELWITHDEBINFO CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_MINSIZEREL CACHE STRING "" FORCE)
  set(CMAKE_C_FLAGS_RELEASE CACHE STRING "" FORCE)

  set(CMAKE_CXX_FLAGS CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_DEBUG CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_RELWITHDEBINFO CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_MINSIZEREL CACHE STRING "" FORCE)
  set(CMAKE_CXX_FLAGS_RELEASE CACHE STRING "" FORCE)

  set(CMAKE_CUDA_FLAGS CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_DEBUG CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_RELWITHDEBINFO CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_MINSIZEREL CACHE STRING "" FORCE)
  set(CMAKE_CUDA_FLAGS_RELEASE CACHE STRING "" FORCE)


  set(CFLAGS_LIST $ENV{CFLAGS})
  separate_arguments(CFLAGS_LIST)

  set(CXXFLAGS_LIST $ENV{CXXFLAGS})
  separate_arguments(CXXFLAGS_LIST)

  set(CUDAFLAGS_LIST $ENV{CUDAFLAGS})
  separate_arguments(CUDAFLAGS_LIST)
endmacro()


# ==============================================================================
#                            Dump all relevant flags
# ==============================================================================

macro(dump_flags)
  message("CMAKE_C_FLAGS_INIT ${CMAKE_C_FLAGS_INIT}")
  message("CMAKE_C_FLAGS_DEBUG_INIT ${CMAKE_C_FLAGS_DEBUG_INIT}")
  message("CMAKE_C_FLAGS_RELWITHDEBINFO_INIT ${CMAKE_C_FLAGS_RELWITHDEBINFO_INIT}")
  message("CMAKE_C_FLAGS_MINSIZEREL_INIT ${CMAKE_C_FLAGS_MINSIZEREL_INIT}")
  message("CMAKE_C_FLAGS_RELEASE_INIT ${CMAKE_C_FLAGS_RELEASE_INIT}")

  message("CMAKE_CXX_FLAGS_INIT ${CMAKE_CXX_FLAGS_INIT}")
  message("CMAKE_CXX_FLAGS_DEBUG_INIT ${CMAKE_CXX_FLAGS_DEBUG_INIT}")
  message("CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT ${CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT}")
  message("CMAKE_CXX_FLAGS_MINSIZEREL_INIT ${CMAKE_CXX_FLAGS_MINSIZEREL_INIT}")
  message("CMAKE_CXX_FLAGS_RELEASE_INIT ${CMAKE_CXX_FLAGS_RELEASE_INIT}")

  message("CMAKE_CUDA_FLAGS_INIT ${CMAKE_CUDA_FLAGS_INIT}")
  message("CMAKE_CUDA_FLAGS_DEBUG_INIT ${CMAKE_CUDA_FLAGS_DEBUG_INIT}")
  message("CMAKE_CUDA_FLAGS_RELWITHDEBINFO_INIT ${CMAKE_CUDA_FLAGS_RELWITHDEBINFO_INIT}")
  message("CMAKE_CUDA_FLAGS_MINSIZEREL_INIT ${CMAKE_CUDA_FLAGS_MINSIZEREL_INIT}")
  message("CMAKE_CUDA_FLAGS_RELEASE_INIT ${CMAKE_CUDA_FLAGS_RELEASE_INIT}")

  message("CMAKE_C_FLAGS ${CMAKE_C_FLAGS}")
  message("CMAKE_C_FLAGS_DEBUG ${CMAKE_C_FLAGS_DEBUG}")
  message("CMAKE_C_FLAGS_RELWITHDEBINFO ${CMAKE_C_FLAGS_RELWITHDEBINFO}")
  message("CMAKE_C_FLAGS_MINSIZEREL ${CMAKE_C_FLAGS_MINSIZEREL}")
  message("CMAKE_C_FLAGS_RELEASE ${CMAKE_C_FLAGS_RELEASE}")

  message("CMAKE_CXX_FLAGS ${CMAKE_CXX_FLAGS}")
  message("CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG}")
  message("CMAKE_CXX_FLAGS_RELWITHDEBINFO ${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
  message("CMAKE_CXX_FLAGS_MINSIZEREL ${CMAKE_CXX_FLAGS_MINSIZEREL}")
  message("CMAKE_CXX_FLAGS_RELEASE ${CMAKE_CXX_FLAGS_RELEASE}")

  message("CMAKE_CUDA_FLAGS ${CMAKE_CUDA_FLAGS}")
  message("CMAKE_CUDA_FLAGS_DEBUG ${CMAKE_CUDA_FLAGS_DEBUG}")
  message("CMAKE_CUDA_FLAGS_RELWITHDEBINFO ${CMAKE_CUDA_FLAGS_RELWITHDEBINFO}")
  message("CMAKE_CUDA_FLAGS_MINSIZEREL ${CMAKE_CUDA_FLAGS_MINSIZEREL}")
  message("CMAKE_CUDA_FLAGS_RELEASE ${CMAKE_CUDA_FLAGS_RELEASE}")
endmacro()


# ==============================================================================
#                                Compiler flags
# ==============================================================================

if(CMAKE_C_COMPILER_ID STREQUAL "GNU" OR
   CMAKE_C_COMPILER_ID STREQUAL "Clang" OR
   CMAKE_C_COMPILER_ID STREQUAL "AppleClang" OR
   CMAKE_C_COMPILER_ID STREQUAL "CrayClang" OR
   CMAKE_C_COMPILER_ID STREQUAL "FujitsuClang" OR
   CMAKE_C_COMPILER_ID STREQUAL "IBMClang" OR
   CMAKE_C_COMPILER_ID STREQUAL "IntelLLVM")

  clear_flags()

  add_compile_definitions(
    "$<$<CONFIG:RELWITHDEBINFO>:NDEBUG>"
    "$<$<CONFIG:MINSIZEREL>:NDEBUG>"
    "$<$<CONFIG:RELEASE>:NDEBUG>"
    "$<$<CONFIG:>:NDEBUG>")

  add_compile_options(
    "$<$<COMPILE_LANGUAGE:C>:-Wall;-Wextra;-std=c11;-pedantic>"
    "$<$<COMPILE_LANGUAGE:CXX>:-Wall;-Wextra;-std=c++11;-pedantic>"

    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:DEBUG>>:-O0;-g>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELWITHDEBINFO>>:-O3;-g>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:MINSIZEREL>>:-Os>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELEASE>>:-O3>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:>>:-O3>"

    "$<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:DEBUG>>:-O0;-Xcicc=-O0;-Xptxas=-O0;--compiler-options=-Wall -Wextra -std=c++11 -O0 -g>"
    "$<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:RELWITHDEBINFO>>:--compiler-options=-Wall -Wextra -std=c++11 -O3 -g>"
    "$<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:MINSIZEREL>>:--compiler-options=-Wall -Wextra -std=c++11 -Os>"
    "$<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:RELEASE>>:--compiler-options=-Wall -Wextra -std=c++11 -O3>"
    "$<$<AND:$<COMPILE_LANGUAGE:CUDA>,$<CONFIG:>>:--compiler-options=-Wall -Wextra -std=c++11 -O3>"

    "$<$<COMPILE_LANGUAGE:C>:${CFLAGS_LIST}>"
    "$<$<COMPILE_LANGUAGE:CXX>:${CXXFLAGS_LIST}>"
    "$<$<COMPILE_LANGUAGE:CUDA>:${CUDAFLAGS_LIST}>")

elseif(CMAKE_C_COMPILER_ID STREQUAL "MSVC")

  clear_flags()

  add_compile_definitions(
    "$<$<CONFIG:RELWITHDEBINFO>:NDEBUG>"
    "$<$<CONFIG:MINSIZEREL>:NDEBUG>"
    "$<$<CONFIG:RELEASE>:NDEBUG>"
    "$<$<CONFIG:>:NDEBUG>")

  add_compile_options(
    "$<$<COMPILE_LANGUAGE:C>:/W4;/wd4200;/wd4201;/wd4204;/std:c11>"
    "$<$<COMPILE_LANGUAGE:CXX>:/W4;/wd4200;/wd4201;/wd4204;/std:c++14>"

    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:DEBUG>>:/Od;/Zi;/EHsc;/fp:strict>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELWITHDEBINFO>>:/O2;/Zi;/EHsc;/fp:strict>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:MINSIZEREL>>:/Os;/GS;/EHsc;/fp:strict>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:RELEASE>>:/O2;/GS;/EHsc;/fp:strict>"
    "$<$<AND:$<COMPILE_LANGUAGE:C,CXX>,$<CONFIG:>>:/O2;/GS;/EHsc;/fp:strict>")

else()

  set(CMAKE_C_STANDARD 11)
  set(CMAKE_C_STANDARD_REQUIRED TRUE)

  set(CMAKE_CXX_STANDARD 11)
  set(CXX_STANDARD_REQUIRED TRUE)

endif()


# ==============================================================================
#                                    Various
# ==============================================================================

# configure_file() version that supports generator expressions.
function(xnd_configure_file src target)
  file(READ "${CMAKE_CURRENT_SOURCE_DIR}/${src}" contents)
  string(CONFIGURE "${contents}" contents)
  file(GENERATE OUTPUT "${target}" CONTENT "${contents}")
endfunction()


# find_library() wrapper that prints the real, versioned library name.
macro(xnd_find_library var root_path target)
  if(root_path)
    list(PREPEND CMAKE_FIND_ROOT_PATH ${root_path})
  endif()

  message(STATUS "Looking for system lib${target}")

  find_library(${var} NAMES ${target} REQUIRED CMAKE_FIND_ROOT_PATH_BOTH)

  get_filename_component(tmp ${${var}} REALPATH)
  message(STATUS "Found ${tmp}")

  if(root_path)
    list(REMOVE_AT CMAKE_FIND_ROOT_PATH 0)
  endif()
endmacro()

macro(assert TEST COMMENT)
  if(NOT ${TEST})
    message(FATAL_ERROR "Assertion failed: ${COMMENT}")
  endif()
endmacro()

macro(dump_options)
  message(
    " BUILD_NDTYPES: ${BUILD_NDTYPES}\n"
    " BUILD_XND: ${BUILD_XND}\n"
    " BUILD_GUMATH: ${BUILD_GUMATH}\n"
    " LIB_INSTALL: ${LIB_INSTALL}\n"
    " LIB_INSTALL_MOD_HEADERS: ${LIB_INSTALL_MOD_HEADERS}\n"
    " BUILD_MOD_NDTYPES: ${BUILD_MOD_NDTYPES}\n"
    " BUILD_MOD_XND: ${BUILD_MOD_XND}\n"
    " BUILD_MOD_GUMATH: ${BUILD_MOD_GUMATH}\n"
    " INSTALL_MOD_NDTYPES: ${INSTALL_MOD_NDTYPES}\n"
    " INSTALL_MOD_XND: ${INSTALL_MOD_XND}\n"
    " INSTALL_MOD_GUMATH: ${INSTALL_MOD_GUMATH}\n"
    " MOD_WITH_SYSTEM_LIB: ${MOD_WITH_SYSTEM_LIB}\n"
    " MOD_WITH_XNDLIB: ${MOD_WITH_XNDLIB}\n"
    " MOD_INSTALL: ${MOD_INSTALL}\n\n")
endmacro()
