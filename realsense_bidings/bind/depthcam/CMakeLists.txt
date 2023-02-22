cmake_minimum_required(VERSION 3.21.3)
project(depthcam)

execute_process(COMMAND ${PYTHON_EXECUTABLE} -c "import numpy; print(numpy.get_include())" OUTPUT_VARIABLE NUMPY_INCLUDE OUTPUT_STRIP_TRAILING_WHITESPACE)
message(STATUS "NUMPY_INCLUDE: " ${NUMPY_INCLUDE})
include_directories(${NUMPY_INCLUDE})

find_package(PythonInterp REQUIRED)
find_package(realsense2 2.29.0)
include_directories(${PYTHON_INCLUDE_DIRS})

find_package( OpenCV REQUIRED )
include_directories( ${OpenCV_INCLUDE_DIRS})

SET(SOURCES
  ${CMAKE_CURRENT_SOURCE_DIR}/ndarray_converter.cpp
)

add_subdirectory(pybind11 ${pybind11_SOURCE_DIR} ${pybind11_BINARY_DIR})
pybind11_add_module(depthcam MODULE ../../interfaces/depthcam.cpp ../../dependencies/numpy/ndarray_converter.cpp)

target_link_libraries(depthcam PRIVATE ${OpenCV_LIBS} ${JSONCPP_LIBRARIES} ${realsense2_LIBRARY})
