cmake_minimum_required(VERSION 3.19)

project(
  libxnd
  VERSION 0.3
  LANGUAGES C CXX)

xnd_configure_file(xnd.h ${INCLUDE_OUTPUT_DIRECTORY}/xnd.h)

add_library(xnd
  bitmaps.c
  bounds.c
  copy.c
  equal.c
  shape.c
  split.c
  xnd.c
  "$<${HAVE_CUDA}:cuda/cuda_memory.cu>")

target_link_libraries(xnd PRIVATE
  ndtypes)

set_target_properties(xnd PROPERTIES
  DEFINE_SYMBOL ""
  CUDA_STANDARD 11
  CUDA_STANDARD_REQUIRED ON
  CUDA_ARCHITECTURES 61 61 61
  VERSION 0.3.2
  SOVERSION 0)

if(LIB_INSTALL)
  install(TARGETS xnd
    ARCHIVE DESTINATION "${XND_INSTALL_LIBDIR}"
    LIBRARY DESTINATION "${XND_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${XND_INSTALL_BINDIR}")

  install(FILES "${INCLUDE_OUTPUT_DIRECTORY}/xnd.h"
    DESTINATION "${XND_INSTALL_INCLUDEDIR}")
endif()

# Windows special cases:
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  target_compile_definitions(xnd
     PRIVATE "XND_EXPORT")
endif()
