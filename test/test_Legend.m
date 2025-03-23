% Test script for kml.Legend
% Author: Taro Suzuki
clear;
close all;
clc;
addpath ../

%% Legend
kmlstr = kml.Legend(["Reference","RTK-GNSS"], ["r-","b:"], 3);
kml.Out(mfilename+".kml", kmlstr);