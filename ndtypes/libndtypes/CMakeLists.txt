cmake_minimum_required(VERSION 3.19)

project(
  libndtypes
  VERSION 0.3
  LANGUAGES C CXX)

if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
  set(NDT_SYS_BIG_ENDIAN 1)
elseif(CMAKE_C_BYTE_ORDER STREQUAL "LITTLE_ENDIAN")
  set(NDT_SYS_BIG_ENDIAN 0)
else()
  message(FATAL_ERROR "cannot determine machine endianness")
endif()

xnd_configure_file(ndtypes.h.in ${INCLUDE_OUTPUT_DIRECTORY}/ndtypes.h)

add_library(ndtypes
  alloc.c
  attr.c
  context.c
  copy.c
  encodings.c
  equal.c
  grammar.c
  io.c
  lexer.c
  match.c
  ndtypes.c
  parsefuncs.c
  parser.c
  primitive.c
  seq.c
  substitute.c
  symtable.c
  unify.c
  util.c
  values.c
  compat/bpgrammar.c
  compat/bplexer.c
  compat/export.c
  compat/import.c
  serialize/deserialize.c
  serialize/serialize.c)

set_target_properties(ndtypes PROPERTIES
  DEFINE_SYMBOL ""
  VERSION 0.3.2
  SOVERSION 0)

if(LIB_INSTALL)
  install(TARGETS ndtypes
    ARCHIVE DESTINATION "${XND_INSTALL_LIBDIR}"
    LIBRARY DESTINATION "${XND_INSTALL_LIBDIR}"
    RUNTIME DESTINATION "${XND_INSTALL_BINDIR}")

  install(FILES "${INCLUDE_OUTPUT_DIRECTORY}/ndtypes.h"
    DESTINATION "${XND_INSTALL_INCLUDEDIR}")
endif()

# Build the parsers:
add_custom_target(grammar
  COMMAND bison -Wall -o grammar.c -pndt_yy --defines=grammar.h grammar.y)
set_target_properties(grammar PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD TRUE)

add_custom_target(parser
  COMMAND flex -o lexer.c -Pndt_yy --header-file=lexer.h lexer.l
  DEPENDS grammar)
set_target_properties(parser PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD TRUE)

add_custom_target(bpgrammar
  COMMAND cd compat && bison -Wall -o bpgrammar.c -pndt_bp --defines=bpgrammar.h bpgrammar.y)
set_target_properties(bpgrammar PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD TRUE)

add_custom_target(bpparser
  COMMAND cd compat && flex -o bplexer.c -Pndt_bp --header-file=bplexer.h bplexer.l 
  DEPENDS bpgrammar)
set_target_properties(bpparser PROPERTIES EXCLUDE_FROM_DEFAULT_BUILD TRUE)

# Windows special cases:
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
  target_compile_definitions(ndtypes
     PRIVATE "NDT_EXPORT")

  set_source_files_properties(
    ndtypes.c
    primitive.c
    PROPERTIES
    COMPILE_FLAGS "/wd5105")

  set_source_files_properties(
    grammar.c
    lexer.c
    parser.c
    compat/bpgrammar.c
    compat/bplexer.c
    compat/export.c
    compat/import.c
    PROPERTIES
    COMPILE_DEFINITIONS YY_NO_UNISTD_H=1
    COMPILE_FLAGS "/wd4702 /wd4127")

  set_source_files_properties(
    serialize/serialize.c
    PROPERTIES COMPILE_DEFINITIONS _CRT_SECURE_NO_WARNINGS=1)
endif()

# AIX special cases:
if(CMAKE_C_COMPILER_ID STREQUAL "IBMClang")
  target_link_libraries(ndtypes
   PRIVATE atomic)
endif()
