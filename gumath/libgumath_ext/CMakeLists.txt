cmake_minimum_required(VERSION 3.19)

xnd_configure_file(gumath_ext.h ${INCLUDE_OUTPUT_DIRECTORY}/gumath_ext.h)

add_library(gumath_ext
  examples.c
  graph.c
  pdist.c
  $<$<NOT:$<C_COMPILER_ID:MSVC>>:quaternion.c>)

target_link_libraries(gumath_ext PRIVATE
  gumath
  xnd
  ndtypes
  $<$<C_COMPILER_ID:IBMClang>:m>)

set_target_properties(gumath_ext PROPERTIES
  DEFINE_SYMBOL ""
  VERSION 0.3.2
  SOVERSION 0)

if(LIB_INSTALL)
  install(TARGETS gumath_ext
    ARCHIVE DESTINATION "${XND_INSTALL_LIBDIR}"
    LIBRARY DESTINATION "${XND_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${XND_INSTALL_BINDIR}")

  install(FILES "${INCLUDE_OUTPUT_DIRECTORY}/gumath_ext.h"
    DESTINATION "${XND_INSTALL_INCLUDEDIR}")
endif()

# Windows special cases:
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  target_compile_definitions(gumath_ext
     PRIVATE "GUMATH_EXPORT")
endif()
