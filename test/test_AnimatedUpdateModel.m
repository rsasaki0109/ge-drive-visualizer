% Test script for kml.AnimatedUpdateModel
% Author: Taro Suzuki
clear;
close all;
clc;
addpath ../

%% Settings
% camera
cam.head = 0;
cam.tilt = 50;
cam.range = 30;

% Model
model = "../model/vehicle_gray.dae";

% location, orientation
loc1 = [35.68777685 140.019451842 0];
loc2 = [35.68790685 140.019451842 0];
ori1 = [0 0 0];
ori2 = [30 0 0]; % heading, tilt, roll (deg)

% animation parameter
dt = 1.0; % Time interval
dulation = dt; % The zero means instantaneous movement
delay = 0; % Timing of animation start

%% Generate KML
kml_look0 = kml.LookAt(loc1, cam);
kml_model = kml.Model("Vehicle", model, loc1, ori1);

kml_tour = [];
kml_tour = [kml_tour; kml.WrapFlyTo(kml_look0)];

% Update Model
kml_tour = [kml_tour; kml.AnimatedUpdateModel("Vehicle", dulation, loc2, ori2, [], delay)];
    
% Move camera
kml_tour = [kml_tour; kml.WrapFlyTo(kml.LookAt(loc2, cam), dt)];
kml_tour = kml.WrapTour(kml_tour, "DriveTour");

kml.Out(mfilename+".kml", [kml_look0; kml_model; kml_tour]);