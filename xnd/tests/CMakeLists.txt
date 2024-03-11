cmake_minimum_required(VERSION 3.19)

project(
  libxnd-tests
  VERSION 0.3
  LANGUAGES C CXX)

add_executable(test_xnd
  runtest.c
  test_fixed.c)

target_link_libraries(test_xnd xnd ndtypes)
