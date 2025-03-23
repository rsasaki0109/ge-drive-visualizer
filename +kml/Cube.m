function kmlstr = Cube(cubeid, loc, r, col, alpha, altmode)
% Create placemark for Polygon cube
% Author: Taro Suzuki
arguments
    cubeid  (:,1) string
    loc     (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    r       (1,1) double % cube side length (m)
    col     (:,3) double % [red, green, blue] (0.0 to 1.0)
    alpha   (1,1) double = 1.0 % transparent (0.0 to 1.0)
    altmode (1,:) char {mustBeMember(altmode,{'relativeToGround','absolute'})} = 'relativeToGround'
end
ncube = size(loc, 1);
polyLineWidth = 2.0; % Line width of polygon

if size(cubeid,1)==1 && ncube>1
    cubeid = repmat(cubeid, [ncube 1]);
end

% Convert color to KML HEX format
if size(col,1)==1 && ncube>1
    col = repmat(col, [ncube 1]);
end
chex = kml.col2hex(col, alpha);

kmlstr = [];

% Style
for i=1:ncube
    kmlstr = [kmlstr; sprintf("<Style id=""CS%s"">", cubeid(i))];
    kmlstr = [kmlstr; sprintf("<PolyStyle> id=""CPS%s""", cubeid(i))];
    kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
    kmlstr = [kmlstr; sprintf("</PolyStyle>")];
    kmlstr = [kmlstr; sprintf("<LineStyle>")];
	kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
	kmlstr = [kmlstr; sprintf("<width>%.1f</width>", polyLineWidth)];
	kmlstr = [kmlstr; sprintf("</LineStyle>")];
    kmlstr = [kmlstr; sprintf("</Style>")];
end

kmlcubes = [];
for i=1:ncube
    [v,idx] = kml.calcCubeVertices(loc(i,:), r); % Caliculate cube vertices
    for j=1:size(idx,1)
        vllh = [v(idx(j,:),:); v(idx(j,1),:)]; % LLH of vertex
    
        kmlcubes = [kmlcubes; sprintf("<Placemark id=""CPM%01d-%s"">", j, cubeid(i))];
        kmlcubes = [kmlcubes; sprintf("<visibility>%d</visibility>", all(~isnan(loc(i,:))))];
        kmlcubes = [kmlcubes; sprintf("<styleUrl>#CS%s</styleUrl>", cubeid(i))];
        kmlcubes = [kmlcubes; sprintf("<Polygon>")];
        kmlcubes = [kmlcubes; sprintf("<altitudeMode>%s</altitudeMode>", altmode)];
        kmlcubes = [kmlcubes; sprintf("<outerBoundaryIs>")];
        kmlcubes = [kmlcubes; sprintf("<LinearRing id=""CPL%01d-%s"">", j, cubeid(i))];
        kmlcubes = [kmlcubes; sprintf("<coordinates>")];
        for k=1:size(vllh,1)
            kmlcubes = [kmlcubes; sprintf("%.8f,%.8f,%.3f", vllh(k,2), vllh(k,1), vllh(k,3))]; % Order: Lon,Lat,Alt
        end
        kmlcubes = [kmlcubes; sprintf("</coordinates>")];
        kmlcubes = [kmlcubes; sprintf("</LinearRing>")];
        kmlcubes = [kmlcubes; sprintf("</outerBoundaryIs>")];
        kmlcubes = [kmlcubes; sprintf("</Polygon>")];
        kmlcubes = [kmlcubes; sprintf("</Placemark>")];
    end
end
if ncube>1
    kmlcubes = kml.WrapFolder(kmlcubes, "Cubes");
end
kmlstr = [kmlstr; kmlcubes];