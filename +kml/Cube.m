function kmlstr = Cube(name, loc, r, col, alpha, altmode)
% Create placemark for Polygon cube
% Author: Taro Suzuki
arguments
    name    (1,:) char
    loc     (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    r       (1,1) double % cube side length (m)
    col     (:,3) double % [red, green, blue] (0.0 to 1.0)
    alpha   (1,1) double = 1.0 % transparent (0.0 to 1.0)
    altmode (1,:) char {mustBeMember(altmode,{'relativeToGround','absolute'})} = 'relativeToGround'
end

ncube = size(loc,1);
polyLineWidth = 2.0; % Line width of polygon

% Convert color to KML HEX format
if size(col,1)==1 && ncube>1
    col = repmat(col,ncube,1);
end
chex = kml.col2hex(col,alpha);

kmlstr = [];

% Style
for i=1:ncube
    kmlstr = [kmlstr; sprintf("<Style id=""CS%04d"">", i)];
    kmlstr = [kmlstr; sprintf("<PolyStyle> id=""CPS%04d""", i)];
    kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
    kmlstr = [kmlstr; sprintf("</PolyStyle>")];
    kmlstr = [kmlstr; sprintf("<LineStyle>")];
	kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
	kmlstr = [kmlstr; sprintf("<width>%.1f</width>", polyLineWidth)];
	kmlstr = [kmlstr; sprintf("</LineStyle>")];
    kmlstr = [kmlstr; sprintf("</Style>")];
end

kmlstr = [kmlstr; sprintf("<Folder>")];
kmlstr = [kmlstr; sprintf("<name>%s</name>", name)];
for i=1:ncube
    [v,idx] = kml.calcCubeVertices(loc(i,:), r); % Caliculate cube vertices
    for j=1:size(idx,1)
        vllh = [v(idx(j,:),:); v(idx(j,1),:)]; % LLH of vertex
    
        kmlstr = [kmlstr; sprintf("<Placemark>")];
        kmlstr = [kmlstr; sprintf("<styleUrl>#CS%04d</styleUrl>", i)];
        kmlstr = [kmlstr; sprintf("<Polygon>")];
        kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>", altmode)];
        kmlstr = [kmlstr; sprintf("<outerBoundaryIs>")];
        kmlstr = [kmlstr; sprintf("<LinearRing id=""CPL%04d"">", i)];
        kmlstr = [kmlstr; sprintf("<coordinates>")];
        for j=1:size(idx,1)
            kmlstr = [kmlstr; sprintf("%.8f,%.8f,%.3f", vllh(j,2), vllh(j,1), vllh(j,3))]; % Order: Lon,Lat,Alt
        end
        kmlstr = [kmlstr; sprintf("</coordinates>")];
        kmlstr = [kmlstr; sprintf("</LinearRing>")];
        kmlstr = [kmlstr; sprintf("</outerBoundaryIs>")];
        kmlstr = [kmlstr; sprintf("</Polygon>")];
        kmlstr = [kmlstr; sprintf("</Placemark>")];
    end
end
kmlstr = [kmlstr; sprintf("</Folder>")];