cmake_minimum_required(VERSION 3.19)

project(
  libgumath
  VERSION 0.3
  LANGUAGES C CXX)

xnd_configure_file(gumath.h ${INCLUDE_OUTPUT_DIRECTORY}/gumath.h)

add_library(gumath
  apply.c
  func.c
  nploops.c
  tbl.c
  thread.c
  xndloops.c
  kernels/common.c
  "$<$<BOOL:${MSVC}>:kernels/cpu_device_msvc.cc>"
  kernels/cpu_device_binary.cc
  kernels/cpu_device_unary.cc
  kernels/cpu_host_binary.c
  kernels/cpu_host_unary.c
  "$<${HAVE_CUDA}:kernels/cuda_device_binary.cu>"
  "$<${HAVE_CUDA}:kernels/cuda_device_unary.cu>"
  "$<${HAVE_CUDA}:kernels/cuda_host_binary.c>"
  "$<${HAVE_CUDA}:kernels/cuda_host_unary.c>")

target_link_libraries(gumath PRIVATE
  xnd
  ndtypes
  Threads::Threads)

set_target_properties(gumath PROPERTIES
  DEFINE_SYMBOL ""
  CUDA_STANDARD 11
  CUDA_STANDARD_REQUIRED ON
  CUDA_ARCHITECTURES 61 61 61
  VERSION 0.3.2
  SOVERSION 0)

if(LIB_INSTALL)
  install(TARGETS gumath
    ARCHIVE DESTINATION "${XND_INSTALL_LIBDIR}"
    LIBRARY DESTINATION "${XND_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${XND_INSTALL_BINDIR}")

  install(FILES "${INCLUDE_OUTPUT_DIRECTORY}/gumath.h"
    DESTINATION "${XND_INSTALL_INCLUDEDIR}")
endif()

# Windows special cases:
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  target_compile_definitions(gumath
     PRIVATE "GUMATH_EXPORT")
endif()

# AIX special cases:
if(CMAKE_C_COMPILER_ID STREQUAL "IBMClang")
  target_link_options(gumath
     PRIVATE "-bbigtoc")
endif()
