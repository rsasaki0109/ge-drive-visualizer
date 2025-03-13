function kmlstr = Line(name, loc, lwidth, col, alpha, draworder, altmode)
% Create placemark for LineString
% Author: Taro Suzuki
arguments
    name      (1,:) char
    loc       (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    lwidth    (1,1) double
    col       (1,3) double % [red, green, blue] (0.0 to 1.0)
    alpha     (1,1) double = 1.0 % transparent (0.0 to 1.0)
    draworder (1,1) double = 0 %  integer value
    altmode   (1,:) char {mustBeMember(altmode,{'clampToGround','relativeToGround','absolute'})} = 'clampToGround'
end

% Convert color to KML HEX format
chex = kml.col2hex(col,alpha);

kmlstr = [];
kmlstr = [kmlstr; sprintf("<Placemark>")];
kmlstr = [kmlstr; sprintf("<name>%s</name>", name)];

kmlstr = [kmlstr; sprintf("<Style>")];
kmlstr = [kmlstr; sprintf("<LineStyle>")];
kmlstr = [kmlstr; sprintf("<color>%s</color>", chex)];
kmlstr = [kmlstr; sprintf("<width>%.1f</width>", lwidth)];
kmlstr = [kmlstr; sprintf("</LineStyle>")];
kmlstr = [kmlstr; sprintf("</Style>")];
kmlstr = [kmlstr; sprintf("<LineString>")];
kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>", altmode)];
kmlstr = [kmlstr; sprintf("<gx:drawOrder>%d</gx:drawOrder>", draworder)];
kmlstr = [kmlstr; sprintf("<coordinates>")];
for i=1:size(loc,1)
    kmlstr = [kmlstr; sprintf("%.8f,%.8f,%.3f", loc(i,2), loc(i,1), loc(i,3))]; % Order: Lon,Lat,Alt
end
kmlstr = [kmlstr; sprintf("</coordinates>")];
kmlstr = [kmlstr; sprintf("</LineString>")];

kmlstr = [kmlstr; sprintf("</Placemark>")];