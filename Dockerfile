FROM python:3.7.4

WORKDIR /home

ENV DEBIAN_FRONTEND=noninteractive 
ENV TZ=Europe/Minsk

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \ 
    sudo \ 
    cmake \
    git \
    curl \
    libopencv-dev \ 
    libjpeg-dev \ 
    libpng-dev \ 
    libtiff-dev \  
    libgtk2.0-dev \ 
    python-numpy \ 
    python-pycurl \ 
    keyboard-configuration \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libusb-1.0-0-dev \
    libglfw3-dev \
    freeglut3 \
    at \
    freeglut3-dev \
    nano \
    curl \
    libglfw3-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    at \ 
    udev \
    linux-headers-* \
    libusb-1.0-0-dev 

#update cmake
RUN sudo apt remove cmake -y && \
    wget https://github.com/Kitware/CMake/releases/download/v3.23.0/cmake-3.23.0.tar.gz && \
    tar -xf cmake-3.23.0.tar.gz && \
    cd cmake-3.23.0 && \
    ./configure && \
    make -j$(nproc)  && \
    sudo make install -j$(nproc) 


#install realsense
RUN git clone https://github.com/IntelRealSense/librealsense && \
    cd librealsense && \
    git checkout v2.51.1 && \
    mkdir -p /etc/udev/rules.d && \
    mkdir build && cd build && \
    cmake .. && \
    make install -j$(nproc) && \
    make -j$(nproc)  

#install opencv and python dependencies to run yolov5

COPY requirements.txt .

RUN pip install --upgrade pip && pip install numpy && \
    git clone https://github.com/opencv/opencv_contrib  && \
    cd opencv_contrib  && \
    git fetch --all --tags  && \
    git checkout tags/4.5.5  && \
    cd .. && \
    git clone https://github.com/opencv/opencv.git  && \
    cd opencv  && \
    git checkout tags/4.5.5 && \

    mkdir build && cd build && \
        cmake -DCMAKE_BUILD_TYPE=Release \
        -D CMAKE_CXX_COMPILER=/usr/bin/g++ \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
        -D BUILD_NEW_PYTHON_SUPPORT=ON \
        -D BUILD_opencv_python3=ON \
        -D HAVE_opencv_python3=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D BUILD_opencv_cudacodec=OFF \
        -D WITH_GTK=ON \
        -D CMAKE_BUILD_TYPE=RELEASE \
        -D CUDA_HOST_COMPILER:FILEPATH=/usr/bin/gcc-7 \
        -D ENABLE_PRECOMPILED_HEADERS=OFF \
        -D WITH_TBB=ON \
        -D WITH_OPENMP=ON \
        -D WITH_IPP=ON \
        -D BUILD_EXAMPLES=OFF \
        -D BUILD_DOCS=OFF \
        -D BUILD_PERF_TESTS=OFF \
        -D BUILD_TESTS=OFF \
        -D WITH_CSTRIPES=ON \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
        -D CMAKE_INSTALL_PREFIX=/usr/local/ \
        -D BUILD_opencv_python3=ON         \
        -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
        -D PYTHON3_EXECUTABLE=$(which python3)  \
        -D PYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())")  \
        -D PYTHON3_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
        -D PYTHON3_LIBRARY=$(python3 -c "from distutils.sysconfig import get_config_var;from os.path import dirname,join ; print(join(dirname(get_config_var('LIBPC')),get_config_var('LDLIBRARY')))")  \
        -D PYTHON3_NUMPY_INCLUDE_DIRS=$(python3 -c "import numpy; print(numpy.get_include())")  \
        -D PYTHON3_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())")  \
        -D OPENCV_GENERATE_PKGCONFIG=ON .. \
        -Dopencv_dnn_superres=ON /usr/bin/ && \
        make -j$(nproc) && \
        make install && \
        cd ../../ && \
        pip3 install opencv/build/python_loader && \
        pip install -r requirements.txt

ENTRYPOINT ["cd", "exemple/exemples/src/","&&","python","main.py" ]