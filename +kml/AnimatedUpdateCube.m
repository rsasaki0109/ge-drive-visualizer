function kmlstr = AnimatedUpdateCube(cubeidx, dulation, loc, delay, col, alpha)
% Create AnimatedUpdate for Polygon cube
% Author: Taro Suzuki
arguments
    cubeidx  (:,:) double % Cube index
    dulation (1,1) double
    loc      (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    delay    (1,1) double = 0.0
    col      (:,3) double = [] % [red, green, blue] (0.0 to 1.0)
    alpha    (1,1) double = [] % transparent (0.0 to 1.0)
end

% Convert cube index to cube ID
if size(cubeidx, 1) < size(cubeidx, 2)
    cubeidx = cubeidx';
end
cubeid = string(num2str(cubeidx, "%04d"));
ncube = length(cubeid);

% Convert color to KML HEX format
if ~isempty(col)
    if size(col,1)==1 && ncube>1
        col = repmat(col,ncube,1);
    end
    chex = kml.col2hex(col,alpha);
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:AnimatedUpdate>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>", dulation)];
kmlstr = [kmlstr; sprintf("<Update>")];
kmlstr = [kmlstr; sprintf("<Change>")];

for i=1:ncube
    % Update coordinates
    kmlstr = [kmlstr; sprintf("<LinearRing targetId=""CPL%s"">", cubeid(i))];
    kmlstr = [kmlstr; sprintf("<coordinates>%.8f,%.8f,%.3f</coordinates>", loc(i,2), loc(i,1), loc(i,3))];
    kmlstr = [kmlstr; sprintf("</LinearRing>")];

    % Update color
    if ~isempty(col)
        kmlstr = [kmlstr; sprintf("<PolyStyle targetId=""CPS%s"">", cubeid(i))];
        kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
        kmlstr = [kmlstr; sprintf("</PolyStyle>")];
    end
end

kmlstr = [kmlstr; sprintf("</Change>")];
kmlstr = [kmlstr; sprintf("</Update>")];
kmlstr = [kmlstr; sprintf("<gx:delayedStart>%.3f</gx:delayedStart>",delay)];
kmlstr = [kmlstr; sprintf("</gx:AnimatedUpdate>")];