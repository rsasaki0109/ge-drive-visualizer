function kmlstr = Model(file, name, loc, ori, scale, altmode)
% Create placemark for Model
% Author: Taro Suzuki
arguments
    file    (1,:) char
    name    (1,:) char
    loc     (1,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    ori     (1,3) double % [Heading, Tilt, Roll] (+-360 deg)
    scale   (1,1) double = 1.0
    altmode (1,:) char {mustBeMember(altmode,{'clampToGround','relativeToGround','absolute'})} = 'clampToGround'
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<Placemark>")];
kmlstr = [kmlstr; sprintf("<name>%s</name>", name)];

kmlstr = [kmlstr; sprintf("<Model id=""%s"">", name)];

kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>", altmode)];

kmlstr = [kmlstr; sprintf("<Location id=""%sLoc"">", name)];
kmlstr = [kmlstr; sprintf("<latitude>%.8f</latitude>", loc(1))];
kmlstr = [kmlstr; sprintf("<longitude>%.8f</longitude>", loc(2))];
kmlstr = [kmlstr; sprintf("<altitude>%.3f</altitude>", loc(3))];
kmlstr = [kmlstr; sprintf("</Location>")];

kmlstr = [kmlstr; sprintf("<Orientation id=""%sOri"">", name)];
kmlstr = [kmlstr; sprintf("<heading>%.3f</heading>", ori(1))];
kmlstr = [kmlstr; sprintf("<tilt>%.3f</tilt>", ori(2))];
kmlstr = [kmlstr; sprintf("<roll>%.3f</roll>", ori(3))];
kmlstr = [kmlstr; sprintf("</Orientation>")];

kmlstr = [kmlstr; sprintf("<Scale>")];
kmlstr = [kmlstr; sprintf("<x>%.3f</x>", scale)];
kmlstr = [kmlstr; sprintf("<y>%.3f</y>", scale)];
kmlstr = [kmlstr; sprintf("<z>%.3f</z>", scale)];
kmlstr = [kmlstr; sprintf("</Scale>")];

kmlstr = [kmlstr; sprintf("<Link>")];
kmlstr = [kmlstr; sprintf("<href>%s</href>", file)];
kmlstr = [kmlstr; sprintf("</Link>")];

kmlstr = [kmlstr; sprintf("</Model>")];

kmlstr = [kmlstr; sprintf("</Placemark>")];