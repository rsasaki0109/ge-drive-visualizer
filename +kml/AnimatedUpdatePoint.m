function kmlstr = AnimatedUpdatePoint(pointid, dulation, loc, delay, col, alpha)
% Create AnimatedUpdate for Point
% Author: Taro Suzuki
arguments
    pointid  (:,:) string % Point ID
    dulation (1,1) double
    loc      (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    delay    (1,1) double = 0.0
    col      (:,3) double = [] % [red, green, blue] (0.0 to 1.0)
    alpha    (1,1) double = [] % transparent (0.0 to 1.0)
end
npoint = length(pointid);

% Convert color to KML HEX format
if ~isempty(col)
    if size(col,1)==1 && npoint>1
        col = repmat(col, [npoint 1]);
    end
    chex = kml.col2hex(col, alpha);
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:AnimatedUpdate>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>", dulation)];
kmlstr = [kmlstr; sprintf("<Update>")];
kmlstr = [kmlstr; sprintf("<Change>")];

for i=1:npoint
    % Update coordinates
    kmlstr = [kmlstr; sprintf("<Point targetId=""P%s"">", pointid(i))];
    kmlstr = [kmlstr; sprintf("<coordinates>%.8f,%.8f,%.3f</coordinates>", loc(i,2), loc(i,1), loc(i,3))]; % Order: Lon,Lat,Alt
    kmlstr = [kmlstr; sprintf("</Point>")];
    
    % Update color
    if ~isempty(col)
        kmlstr = [kmlstr; sprintf("<IconStyle targetId=""PIS%s"">", pointid(i))];
        kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
        kmlstr = [kmlstr; sprintf("</IconStyle>")];
    end
end

kmlstr = [kmlstr; sprintf("</Change>")];
kmlstr = [kmlstr; sprintf("</Update>")];
kmlstr = [kmlstr; sprintf("<gx:delayedStart>%.3f</gx:delayedStart>", delay)];
kmlstr = [kmlstr; sprintf("</gx:AnimatedUpdate>")];