% Animation of vehicle driving and Lidar data
% Author: Taro Suzuki
clear;
close all;
clc;

%% Load lidar data
load ./data/vehicle_nagoya/lidar_data
% pc_lidar : pointclouds in Lidar coordinate (
% pos_veh  : vehicle position (gt.Gpos class in MatRTKLIB)
% rxyz_veh : vehicle 3D pose (rx, ry, rz (deg))
% tform_l2v: transformation from lidar to vehicle coordinate

%% Lidar preprocessing
n = length(pc_lidar); % Number of pointcloud
dt = 0.1; % (s) pointcloud is acquired at 10 Hz

% Index of data to be displayed
idx = 1;

% Pointcloud coordinate conversion
% Convert lidar to vehicle coordinate
pc_veh = pctransform(pc_lidar(idx), tform_l2v);

% Convert vehicle to world coordinate
tform_v2enu = rigidtform3d(rxyz_veh(idx,:), pos_veh.enu(idx,:));
pc_enu(idx) = pctransform(pc_veh, tform_v2enu);

% Number of points in pointcloud
npt = pc_lidar(idx).Count;

%% KML settings
% Vehicle 3D model
vehicle_model = "model/vehicle_gray.dae";
vehicle_scale = 1; % Scale of 3D model

% Camera (LookAt parameters)
cam.tilt = 70;  % Tilt angle (deg)
cam.range = 50; % Range (m)

% Line parameters
lw = 3; % Line width
lcol = [1 0 0]; % Red

% Lidar point parameters
cube_model_base = "model/cube/cube";
cube_scale = 1.5; % Cube scale, original cube is 0.2 m
cubeid = "cube"+num2str((1:npt)',"%04d");

%% Location/orientation for Google Earth
% Vehicle
vloc =  [pos_veh.lat pos_veh.lon pos_veh.orthometric]; % lat,lon,absolute height
heading = kml.wrapTo720(kml.unwrap360(-rxyz_veh(:,3)+90)); % +-360 degree for KML
vori = [heading zeros(n,2)]; % heading, tilt, roll (deg)

% Lidar
pcloc = zeros(npt,3); % lidar point location
pccolidx = ones(npt,1); % lidar point color index
pos = gt.Gpos(double(pc_enu.Location), "enu", pos_veh.orgllh, "llh");
pcloc(1:npt,:) = [pos.lat pos.lon pos.orthometric]; % lat,lon,absolute height
pccolidx(1:npt) = round(pc_enu.Intensity)+1; % lidar point intensity (1-256)

%% Generate KML
% Initial camera
cam.head = vori(1,1); % Initial heading
kml_look0 = kml.LookAt(vloc(1,:), cam, "absolute"); 

% 3D model
kml_model = kml.Model("Vehicle", vehicle_model, vloc(1,:), vori(1,:), vehicle_scale, "absolute");

% Lidar point cloud
cube_model = cube_model_base+num2str(pccolidx(:,1),"%04d")+".dae";
kml_lidar = kml.Model(cubeid, cube_model, pcloc(:,:,1), [0 0 0], cube_scale, "absolute");

% Line
kml_line = kml.Line("Line", vloc, lw, lcol);

%% Generate KML file
kml.Out(mfilename+".kml", [kml_look0; kml_model; kml_lidar; kml_line]);

% Convert to KMZ file
zip(mfilename, mfilename+".kml"); % .kml to .zip
movefile(mfilename+".zip", mfilename+".kmz"); % .zip to .kmz
delete(mfilename+".kml"); % delete .kml