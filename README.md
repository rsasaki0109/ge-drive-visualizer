# Google Earth-based Drive Visualizer
![](https://github.com/taroz/Misc/blob/master/data/ge-drive-visualizer/ge-drive-visualizer.gif?raw=true)
- This project visualizes the results of robot and vehicle position and pose estimation and lidar observations using Google Earth. This is very useful for evaluating and demonstrating the results of localization and SLAM.

# Examples
## Comparison of two types of position estimations
`example_compare_two_positions.m`

https://github.com/user-attachments/assets/44f42e9e-c169-410e-93d6-784791bb7219

## Visualization of vehicle driving and lidar data
`example_vehicle_lidar_animation.m`

https://github.com/user-attachments/assets/7cf90a3f-3ca4-4d13-b62e-40bf3530ce5c

https://github.com/user-attachments/assets/cecb54b5-2ec8-4ae7-809b-ce55b559873b

## Drone flight and visualization of lidar data
`example_drone_lidar_animation.m`

https://github.com/user-attachments/assets/cd34e387-e564-4b97-98db-b750061653ff

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
- Long-term lidar data visualization is difficult
  - For animation, the limit is around 4000 points x 150 frames
- It is necessary to increase the memory allocated to Google Earth
  - `Preferences->Cache->Memory Cache Size (MB): 1024`
  - `Preferences->Cache->Disk Cache Size (MB): 2048`
- For large data, it is difficult to change the viewpoint with the mouse, but Movie Maker rendering and video generation work
