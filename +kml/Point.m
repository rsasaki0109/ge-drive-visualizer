function kmlstr = Point(pointid, loc, scale, col, alpha, altmode)
% Create placemark for Point
% Author: Taro Suzuki
arguments
    pointid (:,1) string
    loc     (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    scale   (1,1) double
    col     (:,3) double % [red, green, blue] (0.0 to 1.0)
    alpha   (1,1) double = 1.0 % transparent (0.0 to 1.0)
    altmode (1,:) char {mustBeMember(altmode,{'clampToGround','relativeToGround','absolute'})} = 'clampToGround'
end

npoint = size(loc, 1);

if size(pointid,1)==1 && npoint>1
    pointid = repmat(pointid, [npoint 1]);
end

% Convert color to KML HEX format
if size(col,1)==1 && npoint>1
    col = repmat(col, [npoint 1]);
end
chex = kml.col2hex(col, alpha);

% Simple circle icon
icon = "http://maps.google.com/mapfiles/kml/pal2/icon18.png";

kmlstr = [];

% Style
for i=1:npoint
    kmlstr = [kmlstr; sprintf("<Style id=""PS%s"">", pointid(i))];
    kmlstr = [kmlstr; sprintf("<IconStyle id=""PIS%s"">", pointid(i))];
    kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
    kmlstr = [kmlstr; sprintf("<scale>%.1f</scale>", scale)];
    kmlstr = [kmlstr; sprintf("<Icon><href>%s</href></Icon>", icon)];
    kmlstr = [kmlstr; sprintf("</IconStyle>")];
    kmlstr = [kmlstr; sprintf("</Style>")];
end

% Point
kmlpoints = [];
for i=1:npoint
    kmlpoints = [kmlpoints; sprintf("<Placemark>")];
    kmlpoints = [kmlpoints; sprintf("<styleUrl>#PS%s</styleUrl>", pointid(i))];
    kmlpoints = [kmlpoints; sprintf("<Point id=""P%s"">", pointid(i))];
    kmlpoints = [kmlpoints; sprintf("<altitudeMode>%s</altitudeMode>", altmode)];
    kmlpoints = [kmlpoints; sprintf("<coordinates>%.8f,%.8f,%.3f</coordinates>", loc(i,2), loc(i,1), loc(i,3))]; % Order: Lon,Lat,Alt
    kmlpoints = [kmlpoints; sprintf("</Point>")];
    kmlpoints = [kmlpoints; sprintf("</Placemark>")];
end
if npoint>1
    kmlpoints = kml.WrapFolder(kmlpoints, "Points");
end
kmlstr = [kmlstr; kmlpoints];