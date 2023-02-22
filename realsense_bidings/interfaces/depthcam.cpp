#include <pybind11/pybind11.h>
#include "../dependencies/numpy/ndarray_converter.h"
#include "../src/modules/depthcam.h"

namespace py = pybind11;

PYBIND11_MODULE(depthcam, m) {
    // optional module docstring
    NDArrayConverter::init_numpy();
    m.doc() = "pybind11 depthcam plugin";

    // define add function
    //m.def("add", &add, "A function which adds two numbers");

    // bindings to Pet class
    py::class_<DepthCam>(m, "DepthCam")
        .def(py::init())
        .def("getFrame",                    &DepthCam::getFrame)
        .def_readwrite("frame",             &DepthCam::frame)
        .def_readwrite("depth_frame",       &DepthCam::depth_frame)
        .def("getDepth",                    &DepthCam::getDepth)
        .def("getDist3D",                   &DepthCam::getDist3D)
        .def("show",                        &DepthCam::show);
}
