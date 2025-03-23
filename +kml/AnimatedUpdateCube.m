function kmlstr = AnimatedUpdateCube(cubeid, dulation, loc, r, col, alpha, delay)
% Create AnimatedUpdate for Polygon cube
% Author: Taro Suzuki
arguments
    cubeid   (:,:) string % Cube ID
    dulation (1,1) double
    loc      (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    r        (1,1) double % cube side length (m)
    col      (:,3) double = [] % [red, green, blue] (0.0 to 1.0)
    alpha    (1,1) double = 1.0 % transparent (0.0 to 1.0)
    delay    (1,1) double = 0.0
end
ncube = length(cubeid);

% Convert color to KML HEX format
if ~isempty(col)
    if size(col,1)==1 && ncube>1
        col = repmat(col, [ncube 1]);
    end
    chex = kml.col2hex(col, alpha);
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:AnimatedUpdate>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>", dulation)];
kmlstr = [kmlstr; sprintf("<Update>")];
kmlstr = [kmlstr; sprintf("<Change>")];

for i=1:ncube
    [v,idx] = kml.calcCubeVertices(loc(i,:), r); % Caliculate cube vertices
    for j=1:size(idx,1)
        vllh = [v(idx(j,:),:); v(idx(j,1),:)]; % LLH of vertex
        
        % Update placemark visibility
        visible = all(~isnan(loc(i,:)));
        kmlstr = [kmlstr; sprintf("<Placemark targetId=""CPM%d-%s"">", j, cubeid(i))];
        kmlstr = [kmlstr; sprintf("<visibility>%d</visibility>", visible)];
        kmlstr = [kmlstr; sprintf("</Placemark>")];
        
        if (visible)
            % Update coordinates
            kmlstr = [kmlstr; sprintf("<LinearRing targetId=""CPL%d-%s"">", j, cubeid(i))];
            kmlstr = [kmlstr; sprintf("<coordinates>")];
            for k=1:size(vllh,1)
                kmlstr = [kmlstr; sprintf("%.8f,%.8f,%.3f", vllh(k,2), vllh(k,1), vllh(k,3))]; % Order: Lon,Lat,Alt
            end
            kmlstr = [kmlstr; sprintf("</coordinates>")];
            kmlstr = [kmlstr; sprintf("</LinearRing>")];
        
            % Update color
            if ~isempty(col)
                kmlstr = [kmlstr; sprintf("<PolyStyle targetId=""CPS%s"">", cubeid(i))];
                kmlstr = [kmlstr; sprintf("<color>%s</color>", chex(i,:))];
                kmlstr = [kmlstr; sprintf("</PolyStyle>")];
            end
        end
    end
end

kmlstr = [kmlstr; sprintf("</Change>")];
kmlstr = [kmlstr; sprintf("</Update>")];
kmlstr = [kmlstr; sprintf("<gx:delayedStart>%.3f</gx:delayedStart>", delay)];
kmlstr = [kmlstr; sprintf("</gx:AnimatedUpdate>")];