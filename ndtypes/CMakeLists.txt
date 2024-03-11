cmake_minimum_required(VERSION 3.19)

project(
  ndtypes
  VERSION 0.3
  LANGUAGES C CXX)

add_subdirectory(libndtypes)
add_subdirectory(tests EXCLUDE_FROM_ALL)

