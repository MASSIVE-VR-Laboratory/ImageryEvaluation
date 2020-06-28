import numpy as np
import cv2
import os
import sys

def createExposureFusion(input_path, filenames):    
# empty stack
    images = []
# load the images, convert them to BGR and populate stack
    for filename in filenames:
        filepath = os.path.join(input_path, filename)
        ldr_img = cv2.imread(filepath, cv2.IMREAD_ANYCOLOR)        
        images.append(ldr_img)
        
# convert the ldr_stack to exposure fusion image
    exp_fusion = cv2.createMergeMertens()
    ldr_fusion = exp_fusion.process(images)
    ldr_fusion *=255
    return ldr_fusion

# End of exposure fusion


if __name__ == "__main__":
    input_path = sys.argv[1]
    filenames = sys.argv[2]
    filenames = filenames.split(" ")
    stem_name = filenames[0].split("_")[0]  # 0th index -> main name without ext    

    ldr_fusion = createExposureFusion(input_path, filenames)
    outname = os.path.join(input_path, stem_name + ".jpg")
    cv2.imwrite(outname, ldr_fusion)    
