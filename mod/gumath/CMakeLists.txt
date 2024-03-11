cmake_minimum_required(VERSION 3.19)


# ==============================================================================
#                                   Project
# ==============================================================================

# NOTE: The CPU, CUDA and example kernels are completely separate modules
# that are packaged with gumath for distribution convenience and to avoid
# namespace collisions.

project(
  mod_gumath
  VERSION 0.3
  LANGUAGES C CXX)


# ==============================================================================
#                                   gumath
# ==============================================================================

xnd_configure_file("__init__.py" "${MODULE_OUTPUT_DIRECTORY}/gumath/__init__.py")
xnd_configure_file("pygumath.h" "${INCLUDE_OUTPUT_DIRECTORY}/pygumath.h")

add_library(_gumath MODULE
  _gumath.c)

target_include_directories(_gumath PRIVATE
 ${Python3_INCLUDE_DIRS})

target_link_libraries(_gumath PRIVATE
  gumath
  xnd
  ndtypes
  ${Python3_LIBRARIES})

set_target_properties(_gumath PROPERTIES
  DEFINE_SYMBOL ""
  PREFIX ""
  OUTPUT_NAME "_gumath"
  SUFFIX "${MODULE_SUFFIX}"
  RUNTIME_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  ARCHIVE_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  LIBRARY_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  INSTALL_RPATH "${MODULE_INSTALL_RPATH}")

if(INSTALL_MOD_GUMATH)
  install(FILES
    "__init__.py"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/gumath")

  install(TARGETS _gumath
    DESTINATION "${CMAKE_INSTALL_PREFIX}/gumath")
endif()


# ==============================================================================
#                                 CPU kernels 
# ==============================================================================

add_library(functions MODULE
  functions.c)

target_include_directories(functions PRIVATE
 ${Python3_INCLUDE_DIRS})

target_link_libraries(functions PRIVATE
  gumath
  xnd
  ndtypes
  ${Python3_LIBRARIES})

set_target_properties(functions PROPERTIES
  DEFINE_SYMBOL ""
  PREFIX ""
  OUTPUT_NAME "functions"
  SUFFIX "${MODULE_SUFFIX}"
  RUNTIME_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  ARCHIVE_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  LIBRARY_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  INSTALL_RPATH "${MODULE_INSTALL_RPATH}")

if(INSTALL_MOD_GUMATH)
  install(TARGETS functions
    DESTINATION "${CMAKE_INSTALL_PREFIX}/gumath")
endif()


# ==============================================================================
#                                 CUDA kernels 
# ==============================================================================

if(HAVE_CUDA)
  add_library(cuda MODULE
    cuda.c)

  target_include_directories(cuda PRIVATE
    ${Python3_INCLUDE_DIRS})

  target_link_libraries(cuda PRIVATE
    gumath
    xnd
    ndtypes
    ${Python3_LIBRARIES})

  set_target_properties(cuda PROPERTIES
    DEFINE_SYMBOL ""
    PREFIX ""
    OUTPUT_NAME "cuda"
    SUFFIX "${MODULE_SUFFIX}"
    RUNTIME_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
    ARCHIVE_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
    LIBRARY_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
    INSTALL_RPATH "${MODULE_INSTALL_RPATH}")

  if(INSTALL_MOD_GUMATH)
    install(TARGETS cuda
      DESTINATION "${CMAKE_INSTALL_PREFIX}/gumath")
  endif()
endif()


# ==============================================================================
#                                 Example kernels 
# ==============================================================================

add_library(examples MODULE
  examples.c)

target_include_directories(examples PRIVATE
  ${Python3_INCLUDE_DIRS})

target_link_libraries(examples PRIVATE
  gumath_ext
  gumath
  xnd
  ndtypes
  PRIVATE ${Python3_LIBRARIES})

set_target_properties(examples PROPERTIES
  DEFINE_SYMBOL ""
  PREFIX ""
  OUTPUT_NAME "examples"
  SUFFIX "${MODULE_SUFFIX}"
  RUNTIME_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  ARCHIVE_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  LIBRARY_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/gumath"
  INSTALL_RPATH "${MODULE_INSTALL_RPATH}")

if(INSTALL_MOD_GUMATH)
  install(TARGETS examples
    DESTINATION "${CMAKE_INSTALL_PREFIX}/gumath")
endif()


# ==============================================================================
#                              Convenience targets
# ==============================================================================

if(HAVE_CUDA)
  add_custom_target(mod_gumath
    DEPENDS _gumath functions cuda examples)
else()
  add_custom_target(mod_gumath
    DEPENDS _gumath functions examples)
endif()
