function kmlstr = Camera(loc, cam, altmode)
% Create Camera
% Author: Taro Suzuki
arguments
    loc     (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    cam     (1,1) % cam.head, cam.tilt, cam.range
    altmode (1,:) char {mustBeMember(altmode,{'clampToGround','relativeToGround','absolute'})} = 'clampToGround '
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<Camera>")];
kmlstr = [kmlstr; sprintf("<latitude>%.8f</latitude>", loc(1))];
kmlstr = [kmlstr; sprintf("<longitude>%.8f</longitude>", loc(2))];
kmlstr = [kmlstr; sprintf("<altitude>%.3f</altitude>", loc(3))];
kmlstr = [kmlstr; sprintf("<heading>%.3f</heading>", cam.head)];
kmlstr = [kmlstr; sprintf("<tilt>%.3f</tilt>", cam.tilt)];
kmlstr = [kmlstr; sprintf("<roll>%.3f</roll>", cam.roll)];
kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>", altmode)];
kmlstr = [kmlstr; sprintf("</Camera>")];
