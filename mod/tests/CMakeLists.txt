cmake_minimum_required(VERSION 3.19)

if(NOT MOD_SELECT)
  xnd_configure_file("bench.py" "${MODULE_OUTPUT_DIRECTORY}/bench.py")
  xnd_configure_file("ndt_randtype.py" "${MODULE_OUTPUT_DIRECTORY}/ndt_randtype.py")
  xnd_configure_file("ndt_support.py" "${MODULE_OUTPUT_DIRECTORY}/ndt_support.py")
  xnd_configure_file("test_ndtypes.py" "${MODULE_OUTPUT_DIRECTORY}/test_ndtypes.py")

  xnd_configure_file("xnd_randvalue.py" "${MODULE_OUTPUT_DIRECTORY}/xnd_randvalue.py")
  xnd_configure_file("xnd_support.py" "${MODULE_OUTPUT_DIRECTORY}/xnd_support.py")
  xnd_configure_file("test_xnd.py" "${MODULE_OUTPUT_DIRECTORY}/test_xnd.py")

  xnd_configure_file("extending.py" "${MODULE_OUTPUT_DIRECTORY}/extending.py")
  xnd_configure_file("gumath_aux.py" "${MODULE_OUTPUT_DIRECTORY}/gumath_aux.py")
  xnd_configure_file("randdec.py" "${MODULE_OUTPUT_DIRECTORY}/randdec.py")
  xnd_configure_file("randfloat.py" "${MODULE_OUTPUT_DIRECTORY}/randfloat.py")
  xnd_configure_file("test_gumath.py" "${MODULE_OUTPUT_DIRECTORY}/test_gumath.py")
  xnd_configure_file("test_xndarray.py" "${MODULE_OUTPUT_DIRECTORY}/test_xndarray.py")
endif()
