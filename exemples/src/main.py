from bin.depthcam import DepthCam 
from modules.model import Model
import cv2

depthcam = DepthCam()
model    = Model()

while True:
    
    depthcam.getFrame()
    frame = depthcam.frame.copy()
    h,w,c = frame.shape
    
    detections = model.predict(frame)

    for detection in detections:
        x0,y0,x1,y1,conf = detection
        
        x_d = int((x0 + x1)/2)
        y_d = int((y0 + y1)/2)
        
        z = depthcam.getDepth(x_d,y_d)

        xi = x_d 
        yi = y_d
        xf = y_d + 100
        yf = y_d
        cv2.circle(frame, (x_d,y_d), radius=10, color=(0, 0, 255), thickness=-1)
        cv2.putText(frame, str(z/1000)+"M", (x_d,y_d+20), 2, 2,(0, 0, 255), 1, cv2.LINE_AA, False) 
        cv2.rectangle(frame, (int(x0),int(y0)), (int(x1),int(y1)), (255,0,0), 2)
    
    cv2.imshow("frame",frame)
    key = cv2.waitKey(1)


