cmake_minimum_required(VERSION 3.19)

project(
  libndtypes-tests
  VERSION 0.3
  LANGUAGES C CXX)

add_executable(test_ndtypes
  alloc_fail.c
  runtest.c
  test_array.c
  test_buffer.c
  test_indent.c
  test_match.c
  test_numba.c
  test_parse.c
  test_parse_error.c
  test_parse_roundtrip.c
  test_record.c
  test_typecheck.c
  test_typedef.c
  test_unify.c)

target_link_libraries(test_ndtypes ndtypes)
