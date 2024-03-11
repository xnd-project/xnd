cmake_minimum_required(VERSION 3.19)

project(
  xnd
  VERSION 0.3
  LANGUAGES C CXX)

add_subdirectory(libxnd)
add_subdirectory(tests EXCLUDE_FROM_ALL)

