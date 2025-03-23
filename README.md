# Google Earth-based Drive Visualizer
- This project visualizes the results of robot and vehicle position and pose estimation and lidar observations using Google Earth. This is very useful for evaluating and demonstrating the results of localization and SLAM.
- KML files can be generated and videos can be recorded using Google Earth functions.

# Examples
## Comparison of two types of position estimations
<p align="center">
  <img width="460" src="https://github.com/taroz/Misc/blob/master/data/ge-gnss-visibility/fisheye.gif?raw=true">
</p>

## Visualization of vehicle driving and lidar data
<p align="center">
  <img width="460" src="https://github.com/taroz/Misc/blob/master/data/ge-drive-visualizer/vehicle_lidar.m4v?raw=true">
  <div><video controls src="https://github.com/taroz/Misc/blob/master/data/ge-drive-visualizer/vehicle_lidar.m4v?raw=true" muted="false"></video></div>
</p>

## Drone flight and visualization of lidar data
<p align="center">
  <img width="460" src="https://github.com/taroz/Misc/blob/master/data/ge-gnss-visibility/fisheye_satellite_nlos.gif?raw=true">
</p>

# Requirements
- MATLAB (>R2022a)
  - `Image Processing Toolbox` and `Computer Vision Toolbox` are required for `example_vehicle_lidar.m` and `example_vehicle_lidar_animation.m`
- [MatRTKLIB](https://github.com/taroz/MatRTKLIB)
- [Google Earth Pro](https://www.google.com/earth/about/versions/#earth-pro)

# How to use
## Setup
- Install [Google Earth Pro](https://www.google.com/earth/about/versions/#earth-pro)
- Clone or download [MatRTKLIB](https://github.com/taroz/MatRTKLIB) and add to path in MATLAB
- Clone or download **ge-drive-visualizer**

## 1. KML generation
Execute the MATLAB script. A `[m-filename].kmz` file will be generated afterwards.
- `example_compare_two_positions.m`: Comparison of two types of position estimations
- `example_drone_lidar_animation.m`: Animation of a drone flight and Lidar data
- `example_vehicle_animation.m`: Animation of a vehicle driving
- `example_vehicle_lidar.m`: Display of vehicle model and Lidar data
- `example_vehicle_lidar_animation.m`: Animation of vehicle driving and Lidar data

## 2. Open `[m-filename].kmz` in Google Earth Pro
- Check `Photorealistic` and `Terrain` in Layers

<img width="600" src="https://github.com/taroz/Misc/blob/master/data/ge-drive-visualizer/cap1.jpg?raw=true">

## 3. Tools->Movie Maker
- Select `DriveTour`
- Enter the name of the file to save to
- Set the video recording settings as you want

![](https://github.com/taroz/Misc/blob/master/data/ge-drive-visualizer/cap2.jpg?raw=true) 

## 4. Click `Create Movie`
- Usually this process takes quite a while!
  - In my experience, running Google Earth in a Linux (Ubuntu) environment is much faster than running it in Windows
  - On Windows, it is faster to use OpenGL instead of DirectX as the graphics mode for Google Earth
  - The type of graphics card you have can also affect performance

![](https://github.com/taroz/Misc/blob/master/data/ge-drive-visualizer/cap3.jpg?raw=true) 

# Note
- In the example of Lidar data animation (`xxx_lidar_animation.m`), there are a large number of objects to be visualized, so there are limits to how much can be displayed in Google Earth
- Long-term visualization is difficult
  - For animation, the limit is around 4000 points x 150 frames per frame
- It is necessary to increase the memory allocated to Google Earth
  - `Preferences->Cache->Memory Cache Size (MB): 1024`
  - `Preferences->Cache->Disk Cache Size (MB): 2048`
- For large data, it is difficult to change the viewpoint with the mouse, but Movie Maker rendering and video generation work