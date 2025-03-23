function [v,idx] = calcCubeVertices(cllh, r)
% Calculate coordinates of the cube vertices
% Author: Taro Suzuki
arguments
    cllh (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    r    (1,1) double % cube side length (m)
end
cllh(isnan(cllh)) = 0;
d = r/2; % (side length)/2
v1 = [-d, -d, -d];
v2 = [d, -d, -d];
v3 = [d, d, -d];
v4 = [-d, d, -d];
v5 = [-d, -d, d];
v6 = [d, -d, d];
v7 = [d, d, d];
v8 = [-d, d, d];
v_enu = [v1; v2; v3; v4; v5; v6; v7; v8];

% Convert to geodetic coordinate
v = rtklib.enu2llh(v_enu, cllh);

idx = [
    % 1, 2, 3, 4; % Bottom, Not drawn to reduce memory usage
    5, 6, 7, 8; % Top
    1, 2, 6, 5; % Front
    2, 3, 7, 6; % Right side
    3, 4, 8, 7; % Back
    4, 1, 5, 8  % Left side
];