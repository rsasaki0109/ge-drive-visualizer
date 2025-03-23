% Display of vehicle model and Lidar data
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

% Pointcloud coordinate conversion
for i=1:n
    % Convert lidar to vehicle coordinate
    pc_veh = pctransform(pc_lidar(i), tform_l2v);

    % Convert vehicle to world coordinate
    tform_v2enu = rigidtform3d(rxyz_veh(i,:), pos_veh.enu(i,:));
    pc_enu(i) = pctransform(pc_veh, tform_v2enu);
    
    % Number of points in pointcloud
    npt(i) = pc_lidar(i).Count; 
end
max_npt = max(npt); % maximum number of points

%% KML settings
% Number of epochs
nep = 100; % 10 seconds (10 Hz)

% Vehicle 3D model
vehicle_model = "model/vehicle_gray.dae";
vehicle_scale = 1; % Scale of 3D model

% Camera (LookAt parameters)
cam.tilt = 70;  % Tilt angle (deg)
cam.range = 50; % Range (m)

% Animation parameters
sppedup = 1;

% Line parameters
lw = 3; % Line width
lcol = [1 0 0]; % Red

% Lidar point parameters
cube_model_base = "model/cube/cube";
cube_scale = 1.5; % Cube scale, original cube is 0.2 m
cubeid = "cube"+num2str((1:max_npt)',"%04d");

%% Location/orientation for Google Earth
% Vehicle
vloc =  [pos_veh.lat pos_veh.lon pos_veh.orthometric]; % lat,lon,absolute height
heading = kml.wrapTo720(kml.unwrap360(-rxyz_veh(:,3)+90)); % +-360 degree for KML
vori = [heading(1:nep) zeros(nep,2)]; % heading, tilt, roll (deg)

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
kml_look0 = kml.LookAt(vloc(1,:), cam, "absolute"); 

% 3D model at initial position
kml_model = kml.Model("Vehicle", vehicle_model, vloc(1,:), vori(1,:), vehicle_scale, "absolute");

% Intial lidar point cloud
cube_model = cube_model_base+num2str(pccolidx(:,1),"%04d")+".dae";
kml_lidar = kml.Model(cubeid, cube_model, pcloc(:,:,1), [0 0 0], cube_scale, "absolute");

% Generate KML Line
kml_line = kml.Line("Line", vloc, lw, lcol);

% Generate KML Tour
kml_tour = [];
kml_tour = [kml_tour; kml.WrapFlyTo(kml_look0)]; % Fly to initial camera position
for i=progress(2:nep)
    % Update 3D model
    kml_tour = [kml_tour; kml.AnimatedUpdateModel("Vehicle", dt/sppedup, vloc(i,:), vori(i,:))];

    % Update Lidar
    cube_model = cube_model_base+num2str(pccolidx(:,i),"%04d")+".dae"; % Update color
    kml_update_lidar = kml.AnimatedUpdateModel(cubeid, 0, pcloc(:,:,i), [], cube_model, dt/sppedup/2);
    kml_tour = [kml_tour; kml_update_lidar];

    % Move camera
    cam.head = vori(i,1);
    kml_tour = [kml_tour; kml.WrapFlyTo(kml.LookAt(vloc(i,:), cam, "absolute"), dt/sppedup)];
end
kml_tour = kml.WrapTour(kml_tour, "DriveTour");

%% Generate KML file
kml.Out(mfilename+".kml", [kml_look0; kml_model; kml_lidar; kml_line; kml_tour]);

% Convert to KMZ file
zip(mfilename, mfilename+".kml"); % .kml to .zip
movefile(mfilename+".zip", mfilename+".kmz"); % .zip to .kmz
delete(mfilename+".kml"); % delete .kml