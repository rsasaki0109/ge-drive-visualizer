% Test script for kml.Cube
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
loc = [35.68777685 140.019451842 1;
       35.68777685 140.019461842 1.5];

% Cube parameter
r = 0.6; % cube side length (m)
col = [1 0 0; 0 0 1];
alpha = 0.8;

%% Generate KML
kml_look0 = kml.LookAt(loc(1,:), cam);
kml_cube = kml.Cube("C"+num2str([1;2]), loc, r, col, alpha, "relativeToGround");

kml.Out(mfilename+".kml", [kml_look0; kml_cube]);