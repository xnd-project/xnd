cmake_minimum_required(VERSION 3.19)

project(
  mod_xnd
  VERSION 0.3
  LANGUAGES C CXX)

xnd_configure_file("__init__.py" "${MODULE_OUTPUT_DIRECTORY}/xnd/__init__.py")
xnd_configure_file("_version.py" "${MODULE_OUTPUT_DIRECTORY}/xnd/_version.py")
xnd_configure_file("contrib/pretty.py" "${MODULE_OUTPUT_DIRECTORY}/xnd/contrib/pretty.py")
xnd_configure_file("pyxnd.h" "${INCLUDE_OUTPUT_DIRECTORY}/pyxnd.h")

add_library(_xnd MODULE
  _xnd.c)

target_include_directories(_xnd PRIVATE
 ${Python3_INCLUDE_DIRS})

target_link_libraries(_xnd PRIVATE
  xnd
  ndtypes
  ${Python3_LIBRARIES})

set_target_properties(_xnd PROPERTIES
  DEFINE_SYMBOL ""
  PREFIX ""
  OUTPUT_NAME "_xnd"
  SUFFIX "${MODULE_SUFFIX}"
  RUNTIME_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/xnd"
  ARCHIVE_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/xnd"
  LIBRARY_OUTPUT_DIRECTORY "${MODULE_OUTPUT_DIRECTORY}/xnd"
  INSTALL_RPATH "${MODULE_INSTALL_RPATH}")

add_custom_target(mod_xnd
  DEPENDS _xnd)

if(INSTALL_MOD_XND)
  install(FILES
    "__init__.py"
    "_version.py"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/xnd")

  install(FILES
    "contrib/pretty.py"
    DESTINATION "${CMAKE_INSTALL_PREFIX}/xnd/contrib")

  install(TARGETS _xnd
    DESTINATION "${CMAKE_INSTALL_PREFIX}/xnd")
endif()
