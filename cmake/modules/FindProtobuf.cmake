#
# CMake package file for Protobuf
#

find_path(PROTOBUF_INCLUDE_DIR google
  HINTS "${CMAKE_BINARY_DIR}/lib/protobuf/install/include")
find_library(PROTOBUF_LIBRARY NAMES protobuf
  HINTS "${CMAKE_BINARY_DIR}/lib/protobuf/install/lib")

set(PROTOBUF_LIBRARIES ${PROTOBUF_LIBRARY})
set(PROTOBUF_INCLUDE_DIRS ${PROTOBUF_INCLUDE_DIR})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(PROTOBUF
  DEFAULT_MSG PROTOBUF_LIBRARY PROTOBUF_INCLUDE_DIR)
