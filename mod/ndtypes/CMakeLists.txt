cmake_minimum_required(VERSION 3.19)

project(
  mod_ndtypes
  VERSION 0.3
  LANGUAGES C CXX)

xnd_configure_file("__init__.py" "${MODULE_OUTPUT_DIRECTORY}/ndtypes/__init__.py")
xnd_configure_file("pyndtypes.h" "${INCLUDE_OUTPUT_DIRECTORY}/pyndtypes.h")

add_library(_ndtypes MODULE
  _ndtypes.c)

target_include_directories(_ndtypes PRIVATE
  ${Python3_INCLUDE_DIRS})

target_link_libraries(_ndtypes PRIVATE
  ndtypes
  ${Python3_LIBRARIES})

set_target_properties(_ndtypes PROPERTIES
  DEFINE_SYMBOL ""
  PREFIX ""
  OUTPUT_NAME "_ndtypes"
  SUFFIX "${MODULE_SUFFIX}"
  RUNTIME_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/ndtypes"
  ARCHIVE_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/ndtypes"
  LIBRARY_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/ndtypes"
  INSTALL_RPATH "${MODULE_INSTALL_RPATH}")

add_custom_target(mod_ndtypes
  DEPENDS _ndtypes)

if(INSTALL_MOD_NDTYPES)
  install(FILES
    "__init__.py"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/ndtypes")

  install(TARGETS _ndtypes
    DESTINATION "${CMAKE_INSTALL_PREFIX}/ndtypes")
endif()
