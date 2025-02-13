clear;
close all;
clc;

%% Settings
% 3D model
daefile1 = "model/vehicle_red.dae";
daefile2 = "model/vehicle_blue.dae";
scale = 1; % Scale of 3D model

% Name
name1 = "Vehicle1";
name2 = "Vehicle2";

% Camera (LookAt parameters)
cam.tilt = 70;  % Tilt angle (deg)
cam.range = 40; % Range (m)

% Animation parameters
sppedup = 3;
dt = 1.0; % (s)

% Line/Point parameters
lw = 3; % Line width
col1 = [1 0 0]; % Red
col2 = [0 0 1]; % Blue
alpha = 0.6; % Transparency (0-1)
pscale = 0.3; % Point scale

%% Read data
ref = readmatrix("data/reference.csv");
n = size(ref,1);

% Reference trajectory
pos1 = gt.Gpos(ref(:,3:5),"llh");
ori1 = [ref(:,11) zeros(n,2)]; % heading, tilt, roll (deg)

% SPP trajectory
sol = gt.Gsol("data/rover.pos");
sol = sol.fixedInterval(sol.dt);
pos2 = sol.pos;
ori2 = ori1;

% Antenna lever arm compensation
arm = [0.0 0.4]'; % Only x-y
rotm = @(x) [cosd(x) -sind(x); sind(x) cosd(x)];
for i=1:pos1.n
    offset(i,:) = [(rotm(-ori1(i,1)+90)*arm)' 0];
end
pos1.addOffset(offset);
pos2.addOffset(offset);

loc1 = [pos1.lat pos1.lon zeros(pos1.n,1)];
loc2 = [pos2.lat pos2.lon zeros(pos2.n,1)];

% Fill NaN
loc1 = fillmissing(loc1,"previous");
loc2 = fillmissing(loc2,"previous");

%% Generate KML
% Generate KML 3D model at initial position
kml_model1 = kml.Model(daefile1, name1, loc1(1,:), ori1(1,:), scale);
kml_model2 = kml.Model(daefile2, name2, loc2(1,:), ori2(1,:), scale);

% Initial camera
cam.head = ori1(1,1); % Initial heading
kml_look0 = kml.LookAt(loc1(1,:),cam); 

% Generate KML Tour
kml_tour = [];
kml_tour = [kml_tour; kml.FlyTo(kml_look0)]; % Fly to initial camera position
for i=2:n
    % 3D model animation
    kml_tour = [kml_tour; kml.AnimatedUpdate(name1, dt/sppedup, loc1(i,:), ori1(i,:))];
    kml_tour = [kml_tour; kml.AnimatedUpdate(name2, dt/sppedup, loc2(i,:), ori2(i,:))];
    
    % Move camera
    cam.head = ref(i,11);
    kml_tour = [kml_tour; kml.FlyTo(kml.LookAt(loc1(i,:),cam),dt/sppedup)];
end
kml_tour = kml.Tour(kml_tour, "DriveTour");

% Generate KML Line
kml_line1 = kml.Line(name1, loc1, lw, col1, alpha, 1);
kml_line2 = kml.Line(name2, loc2, lw, col2, alpha, 0);

% Generate KML Point
kml_point1 = kml.Point(name1, loc1, pscale, col1, alpha);
kml_point2 = kml.Point(name2, loc2, pscale, col2, alpha);

% Generate KML file
kml.Out("DriveTour.kml", [kml_look0; kml_tour; kml_model1; kml_line1; kml_line2; kml_model2; kml_point1; kml_point2]);