% Comparison of two types of position estimations
% Author: Taro Suzuki
clear;
close all;
clc;

%% Load reference trajectory
ref = readmatrix("data/vehicle_tokyo/reference.csv");
n = size(ref, 1);
dt = 1.0; % Time interval (s)

% Vehicle position/heading
pos_ref = gt.Gpos(ref(:,3:5),"llh");
heading = kml.wrapTo720(kml.unwrap360(ref(:,11))); % +-360 degree for KML

% Vehicle location/orientation for google earth
vloc_ref = [pos_ref.lat pos_ref.lon pos_ref.orthometric]; % lat,lon,absolute height
vori_ref = [heading zeros(n,2)]; % heading, tilt, roll (deg)

% Fill NaN
vloc_ref = fillmissing(vloc_ref, "previous"); 
vori_ref = fillmissing(vori_ref, "previous");

%% Load RTK-GNSS trajectory
sol_rtk = gt.Gsol("data/vehicle_tokyo/spp.pos");
sol_rtk = sol_rtk.fixedInterval(dt);

% Vehicle location/orientation for google earth
vloc_rtk = [sol_rtk.pos.lat sol_rtk.pos.lon pos_ref.orthometric]; % We use reference height
vori_rtk = [heading zeros(n,2)]; % We use reference orientation

% Fill NaN
vloc_rtk = fillmissing(vloc_rtk, "previous"); 
vori_rtk = fillmissing(vori_rtk, "previous");

%% Settings
% 3D model
vehicle_model_ref = "model/vehicle_red.dae";
vehicle_model_rtk = "model/vehicle_blue.dae";
vehicle_scale = 1; % Scale of 3D model

% Camera (LookAt parameters)
cam.tilt = 50;  % Tilt angle (deg)
cam.range = 90; % Range (m)

% Animation parameters
sppedup = 5;

% Line parameters
lw = 3; % Line width
lcol_ref = [1 0 0]; % Red
lcol_rtk = [0 0 1]; % Blue
lalpha = 0.8; % Transparency (0 to 1)

% point parameters
pscale = 0.5; % Point scale
pcol_ref = [1 0 0]; % Red
pcol_rtk = [0 0 1]; % Blue
palpha = 0.8; % Transparency (0 to 1)

%% Generate KML
% Initial camera
cam.head = vori_ref(1,1); % Initial heading
kml_look0 = kml.LookAt(vloc_ref(1,:), cam, "absolute"); 

% 3D model at initial position
kml_model_ref = kml.Model("Vehicle_ref", vehicle_model_ref, vloc_ref(1,:), vori_ref(1,:), vehicle_scale, "absolute");
kml_model_rtk = kml.Model("Vehicle_rtk", vehicle_model_rtk, vloc_rtk(1,:), vori_rtk(1,:), vehicle_scale, "absolute");

% Line
kml_line_ref = kml.Line("Line_ref", vloc_ref, lw, lcol_ref, lalpha, 1);
kml_line_rtk = kml.Line("Line_rtk", vloc_rtk, lw, lcol_rtk, lalpha, 0);

% Point
kml_point_ref = kml.Point("Point_ref", vloc_ref, pscale, pcol_ref, palpha);
kml_point_rtk = kml.Point("Point_rtk", vloc_rtk, pscale, pcol_rtk, palpha);

% Generate KML Tour
kml_tour = [];
kml_tour = [kml_tour; kml.WrapFlyTo(kml_look0)]; % Fly to initial camera position
for i=progress(2:n)
    % Update 3D model
    kml_tour = [kml_tour; kml.AnimatedUpdateModel("Vehicle_ref", dt/sppedup, vloc_ref(i,:), vori_ref(i,:))];
    kml_tour = [kml_tour; kml.AnimatedUpdateModel("Vehicle_rtk", dt/sppedup, vloc_rtk(i,:), vori_rtk(i,:))];

    % Move camera
    cam.head = vori_ref(i,1);
    kml_tour = [kml_tour; kml.WrapFlyTo(kml.LookAt(vloc_ref(i,:), cam, "absolute"), dt/sppedup)];
end
kml_tour = kml.WrapTour(kml_tour, "DriveTour");

% Legend
kml_legend = kml.Legend(["Reference" "Single Point Positioning"],["r-","b-"]);

%% Generate KML file
kml.Out(mfilename+".kml", [kml_look0; kml_model_ref; kml_model_rtk; kml_line_ref; kml_line_rtk; kml_point_ref; kml_point_rtk; kml_tour; kml_legend]);

% Convert to KMZ file
zip(mfilename, mfilename+".kml"); % .kml to .zip
movefile(mfilename+".zip", mfilename+".kmz"); % .zip to .kmz
delete(mfilename+".kml"); % delete .kml