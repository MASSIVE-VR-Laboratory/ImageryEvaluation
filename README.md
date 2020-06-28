# Introduction
This repository was created to explore the feasibility of using expansion operators to construct HDR images from LDR images in order to train HDR object detection models. 
The repository consists of of HDR to LDR mapping techniques along with multiple expansion operators. The HDR to LDR mapping techniques are used to map original HDR images to LDR images. The LDR images are subsequently expanded back to HDR using several mapping techniques. The predicted (reconstructed) HDR images are compared with the original HDR images using the following metrics:
  1) HDR-VDP2 http://www.cs.ubc.ca/labs/imager/tr/2011/Mantiuk_HDR-VDP-2/
  2) puPSNR and puSSIM (HDR versions of PSNR and SSIM)
  
# Expansion operators used:
In this work, we have used some external repositories for different expansion operators. Some are already included in the matlab code and some of the other deep learning based ones are in the following links (forked from the original repo):
### HDRExpandnet
```
https://github.com/MASSIVE-VR-Laboratory/hdr-expandnet
```
### HDRCNN
```
https://github.com/gabrieleilertsen/hdrcnn
```
