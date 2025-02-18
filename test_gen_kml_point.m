clear;
close all;
clc;

%% Settings
% Camera (LookAt parameters)
cam.head = 0; % Heading angle (deg)
cam.tilt = 40;  % Tilt angle (deg)
cam.range = 1500; % Range (m)

% Animation parameters
sppedup = 3;
dt = 1.0; % (s)

% Line/Point parameters
lw = 3; % Line width
lcol = [1 0 0]; % Red
ps = 1.0; % Point scale
pcol = [1 1 0]; % Yellow
alpha = 1.0; % Transparency (0-1)

%% Read data
ref = readmatrix("data/reference.csv");
n = size(ref,1);

% Reference trajectory
pos1 = gt.Gpos(ref(:,3:5),"llh");
loc1 = [pos1.lat pos1.lon zeros(pos1.n,1)];

%% Generate KML
% Generate KML 3D model at initial position
kml_point = kml.Point("Point", loc1(1,:), ps, pcol, alpha);

% Initial camera
kml_look0 = kml.LookAt(mean(loc1),cam); 

% Generate KML Tour
kml_tour = [];
for i=1:n
    % Point animation
    kml_tour = [kml_tour; kml.AnimatedUpdatePoint(1,dt/sppedup,loc1(i,:),0)];
    
    % When the camera is not moving, insert "Wait" instead of "FlyTo"
    kml_tour = [kml_tour; kml.Wait(dt/sppedup)];
end
kml_tour = kml.Tour(kml_tour, "PointMove");

% Generate KML Line
kml_line = kml.Line("Line", loc1, lw, lcol, alpha);

% Generate KML file
kml.Out("PointMove.kml", [kml_look0; kml_tour; kml_point; kml_line]);