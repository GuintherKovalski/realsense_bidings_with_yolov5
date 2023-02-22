# Realsense python bidings with YOLOv5 integration

 > This is a lightweight implementation of realsense bidings for python from c++. The goal is to use the realsense camera along with some exemples on how to use it in some computer vision projects. 
 
 **Note: Realsense already provide python bidings, but in our experiments they run slower than the ones provided here, and also are more complicated to use.**
 
 ![pl](images/exemple.png) 

The bindings provided here aim to be as simple to use as:

- `from bin.depthcam import DepthCam` 
- `depthcam = DepthCam()`
- `z = depthcam.getDepth(x,y)`

And gets z in millimeters from the x and y pixel positions in the image.

## Installation
### Prerequisites
* A realsense camera.
* Python installed.

run:
`docker build -t realsense_yolo:latest .`

## Usage
There is an exemple of usage at `exemples/src/main.py`, you can also run `bash run_container.sh`




