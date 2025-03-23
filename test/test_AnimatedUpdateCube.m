% Test script for kml.AnimatedUpdateCube
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

% location, orientation
loc1 = [35.68777685 140.019451842 1.0;
        35.68777685 140.019461842 1.5];

loc2 = [35.68790685 140.019451842 2.0;
        35.68790685 140.019461842 2.5];

col1 = [1 0 0; 0 0 1];
col2 = [0 1 0; 0 1 1];
alpha = 0.8;

ori = [0 0 0;
       0 0 0];

% Cube parameter
r = 0.6; % cube side length (m)

% animation parameter
dt = 1.0; % Time interval
dulation = 0; % The zero means instantaneous movement
delay = dt/2; % Timing of animation start

%% Generate KML
kml_look0 = kml.LookAt(loc1(1,:), cam);
kml_cube = kml.Cube("C"+num2str([1;2]), loc1, r, col1, alpha, "relativeToGround");

kml_tour = [];
kml_tour = [kml_tour; kml.WrapFlyTo(kml_look0)];

% Update cube
kml_tour = [kml_tour; kml.AnimatedUpdateCube("C"+num2str([1;2]), dulation, loc2, r, col2, alpha, delay)];
    
% Move camera
kml_tour = [kml_tour; kml.WrapFlyTo(kml.LookAt(loc2(1,:), cam), dt)];
kml_tour = kml.WrapTour(kml_tour,"DriveTour");

kml.Out(mfilename+".kml", [kml_look0; kml_cube; kml_tour]);