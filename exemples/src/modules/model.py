import torch

class Model:
    def __init__(self) -> None:
        self.engine = torch.hub.load('ultralytics/yolov5', 'yolov5s') 
    
    def predict(self,img):
        
        results    = self.engine(img)
        detections = results.pred[0].detach().cpu().numpy()

        return detections[detections[:,5]==0][:,:5]
