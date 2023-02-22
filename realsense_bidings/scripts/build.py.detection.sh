

#building depthcam module
echo "***************************************************************************"
echo "                          building depthcam module                         "
echo "***************************************************************************"

cd ../bind/depthcam
cp -r ../../pybind11/ .
rm -rf build
mkdir build && cd build && cmake .. && make
mv *.so ../../../bin
cd ..
rm -rf pybind11
rm -rf build



