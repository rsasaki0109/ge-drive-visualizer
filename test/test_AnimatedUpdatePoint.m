% Test script for kml.AnimatedUpdatePoint
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
loc1 = [35.68777685 140.019451842 0;
        35.68777685 140.019461842 0];

loc2 = [35.68790685 140.019451842 0;
        35.68790685 140.019461842 0];

col1 = [1 0 0; 0 0 1];
col2 = [0 1 0; 0 1 1];
alpha = 0.8;

ori = [0 0 0;
       0 0 0];

% animation parameter
dt = 1.0; % Time interval
dulation = 0; % The zero means instantaneous movement
delay = dt/2; % Timing of animation start

%% Generate KML
kml_look0 = kml.LookAt(loc1(1,:), cam);
kml_point = kml.Point("P"+num2str([1;2]), loc1, 1, col1, alpha);

kml_tour = [];
kml_tour = [kml_tour; kml.WrapFlyTo(kml_look0)];

% Update point
kml_tour = [kml_tour; kml.AnimatedUpdatePoint("P"+num2str([1;2]), dulation, loc2, delay, col2, alpha)];
    
% Move camera
kml_tour = [kml_tour; kml.WrapFlyTo(kml.LookAt(loc2(1,:), cam), dt)];
kml_tour = kml.WrapTour(kml_tour,"DriveTour");

kml.Out(mfilename+".kml", [kml_look0; kml_point; kml_tour]);