export DISPLAY=:1
xhost +

sudo docker run -it --privileged -v /home/pixlog/Desktop/EmpilhadeiraAutonoma/autonomous:/home/autonomous \
    -v /home/pixlog/Desktop/EmpilhadeiraAutonoma/facpp:/home/facpp \
    -v /etc/udev/*:/etc/udev/* \
    -v /dev/bus/usb:/dev/bus/usb \
    -v /dev/:/dev/ \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY=$DISPLAY -h $HOSTNAME -v $HOME/.Xauthority:/home/.Xauthority realsense:prod bash
