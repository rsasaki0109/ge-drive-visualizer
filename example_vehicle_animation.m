% Animation of a vehicle driving
% Author: Taro Suzuki
clear;
close all;
clc;

%% Load reference trajectory
ref = readmatrix("data/vehicle_nagoya/reference.csv");
n = size(ref, 1);
dt = 1.0; % Time interval (s)

% Vehicle position/heading
pos = gt.Gpos(ref(:,3:5),"llh");
heading = kml.wrapTo720(kml.unwrap360(ref(:,11))); % +-360 degree for KML

% Vehicle location/orientation for google earth
vloc = [pos.lat pos.lon pos.orthometric]; % lat,lon,absolute height
vori = [heading zeros(n,2)]; % heading, tilt, roll (deg)

%% KML settings
% Vehicle 3D model
vehicle_model = "model/vehicle_gray.dae";
vehicle_scale = 1; % Scale of 3D model

% Camera (LookAt parameters)
cam.tilt = 50;  % Tilt angle (deg)
cam.range = 90; % Range (m)

% Animation parameters
sppedup = 5;

% Line parameters
lw = 3; % Line width
lcol = [1 0 0]; % Red
lalpha = 0.8; % Transparency (0 to 1)

% point parameters
pscale = 0.5; % Point scale
pcol = [1 0 0]; % Red
palpha = 0.8; % Transparency (0 to 1)

%% Generate KML
% Initial camera
cam.head = vori(1,1); % Initial heading
kml_look0 = kml.LookAt(vloc(1,:), cam, "absolute"); 

% 3D model at initial position
kml_model = kml.Model("Vehicle", vehicle_model, vloc(1,:), vori(1,:), vehicle_scale, "absolute");

% Line
kml_line = kml.Line("Line", vloc, lw, lcol, lalpha);

% Point
kml_point = kml.Point("Point", vloc, pscale, pcol, palpha);

% Generate KML Tour
kml_tour = [];
kml_tour = [kml_tour; kml.WrapFlyTo(kml_look0)]; % Fly to initial camera position
for i=2:n
    % Update 3D model
    kml_tour = [kml_tour; kml.AnimatedUpdateModel("Vehicle", dt/sppedup, vloc(i,:), vori(i,:))];

    % Move camera
    cam.head = vori(i,1);
    kml_tour = [kml_tour; kml.WrapFlyTo(kml.LookAt(vloc(i,:), cam, "absolute"), dt/sppedup)];
end
kml_tour = kml.WrapTour(kml_tour, "DriveTour");

%% Generate KML file
kml.Out(mfilename+".kml", [kml_look0; kml_model; kml_line; kml_point; kml_tour]);

% Convert to KMZ file
zip(mfilename, mfilename+".kml"); % .kml to .zip
movefile(mfilename+".zip", mfilename+".kmz"); % .zip to .kmz
delete(mfilename+".kml"); % delete .kml