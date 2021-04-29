### Hand Pose Detection

<p align="center">
<img width="150" height="300" src="https://user-images.githubusercontent.com/22526834/116620031-ef741100-a949-11eb-9bec-bbfc29353f0c.GIF">
</p>

This repository contains an iOS application that detects and displays hand joints from a live video stream.

#### 1) Requirements

- Xcode
- An iPhone with iOS 11+

#### 2) How Hand Pose Estimation Works

Hand pose estimation part is performed using Apple's Vision Framework [1]

A Vision request consists of 3 components:  

**Request**: what you want Vision to do.  
> As we want to perform hand pose estimation, we use *VNDetectHumanHandPoseRequest*.  

**Request Handler**: how Vision performs the request.  
takes the input → processes it according to the request → returns the result
> As we are interested in image analysis, we use *VNImageRequestHandler*.  


**Observation**: output that we want from Vision.  
> In the case of hand pose estimation, observation is a bunch of points corresponding to the detected hand joint locations.


#### 3) References
[1] https://developer.apple.com/documentation/vision
