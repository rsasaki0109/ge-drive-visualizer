% Animation of a drone flight and Lidar data
% Author: Taro Suzuki
clear;
close all;
clc;

%% Load lidar data
load ./data/drone/lidar_data
% pc_world : pointclouds in world coordinate
% pos_veh  : vehicle position in world coordinate (gt.Gpos class in MatRTKLIB)
% rxyz_veh : vehicle 3D pose (rx, ry, rz (deg))
% tform_l2v: transformation from lidar to vehicle coordinate

%% Lidar preprocessing
n = length(pc_enu); % Number of pointcloud
dt = 0.5; % (s) pointcloud is acquired at 2 Hz

% Pointcloud coordinate conversion
for i=1:n
    % Number of points in pointcloud
    npt(i) = pc_enu(i).Count; 
end
max_npt = max(npt); % maximum number of points

%% KML settings
% Number of epochs
nep = 300; % 150 seconds (2 Hz)

% Vehicle 3D model
vehicle_model = "model/drone.dae";
vehicle_scale = 5; % Scale of 3D model

% Camera (Camera parameters)
cam.tilt = 35;  % Tilt angle (deg)
cam.roll = 0; % Roll angle (deg)
cam.dx = -50; % m
cam.dz = 50; % m
rotm = @(x) [cosd(x) -sind(x); sind(x) cosd(x)];

% Animation parameters
sppedup = 5;

% Line parameters
lw = 2; % Line width
lcol = [1 0 0]; % Red

% Lidar point parameters
cube_model_base = "model/cube/cube";
cube_scale = 2; % Cube scale, original cube is 0.2 m
cubeid = "cube"+num2str((1:max_npt)',"%04d");

%% Location/orientation for Google Earth
% Vehicle
vloc =  [pos_veh.lat pos_veh.lon pos_veh.orthometric]; % lat,lon,absolute height
heading = kml.wrapTo720(kml.unwrap360(-rxyz_veh(:,3)+90)); % +-360 degree for KML
vori = [heading rxyz_veh(:,2) rxyz_veh(:,1)]; % heading, tilt, roll (deg)

% Lidar
pcloc = zeros(max_npt,3,nep); % lidar point location
pccolidx = ones(max_npt,nep); % lidar point color index
for i=1:nep
    pos = gt.Gpos(double(pc_enu(i).Location), "enu", pos_veh.orgllh, "llh");
    pcloc(1:npt(i),:,i) = [pos.lat pos.lon pos.orthometric]; % lat,lon,absolute height
    pccolidx(1:npt(i),i) = round(pc_enu(i).Intensity)+1; % lidar point intensity (1-256)
end

%% Generate KML
% Initial camera
cam.head = vori(1,1); % Initial heading
pos_cam = pos_veh.select(1);
dxyz = [(rotm(-cam.head+90)*[cam.dx; 0])' cam.dz];
pos_cam.addOffset(dxyz);
cloc = [pos_cam.lat pos_cam.lon pos_cam.orthometric];
kml_camera0 = kml.Camera(cloc, cam, "absolute"); 

% 3D model at initial position
kml_model = kml.Model("Vehicle", vehicle_model, vloc(1,:), vori(1,:), vehicle_scale, "absolute");

% Intial lidar point cloud
cube_model = cube_model_base+num2str(pccolidx(:,1),"%04d")+".dae";
kml_lidar = kml.Model(cubeid, cube_model, pcloc(:,:,1), [0 0 0], cube_scale, "absolute");

% Generate KML Line
kml_line = kml.Line("Line", vloc, lw, lcol, 1, 0, "absolute");

% Generate KML Tour
kml_tour = [];
kml_tour = [kml_tour; kml.WrapFlyTo(kml_camera0)]; % Fly to initial camera position
for i=2:nep
    % Update 3D model
    kml_tour = [kml_tour; kml.AnimatedUpdateModel("Vehicle", dt/sppedup, vloc(i,:), vori(i,:))];

    % Update Lidar
    cube_model = cube_model_base+num2str(pccolidx(:,i),"%04d")+".dae"; % Update color
    kml_update_lidar = kml.AnimatedUpdateModel(cubeid, 0, pcloc(:,:,i), [], cube_model, dt/sppedup/2);
    kml_tour = [kml_tour; kml_update_lidar];

    % Move camera
    pos_cam = pos_veh.select(i);
    cam.head = vori(i,1);
    dxyz = [(rotm(-cam.head+90)*[cam.dx; 0])' cam.dz];
    pos_cam.addOffset(dxyz);
    cloc = [pos_cam.lat pos_cam.lon pos_cam.orthometric];
    kml_tour = [kml_tour; kml.WrapFlyTo(kml.Camera(cloc, cam, "absolute"), dt/sppedup)];

    fprintf("%d/%d...\n",i,nep);
end
kml_tour = kml.WrapTour(kml_tour, "DriveTour");

%% Generate KML file
kml.Out(mfilename+".kml", [kml_camera0; kml_model; kml_lidar; kml_line; kml_tour]);

% Convert to KMZ file
zip(mfilename, mfilename+".kml"); % .kml to .zip
movefile(mfilename+".zip", mfilename+".kmz"); % .zip to .kmz
delete(mfilename+".kml"); % delete .kml