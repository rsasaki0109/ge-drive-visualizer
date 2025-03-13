function kmlstr = AnimatedUpdateModel(modelname, dulation, loc, ori, delay)
% Create AnimatedUpdate for Model
% Author: Taro Suzuki
arguments
    modelname (1,:) char
    dulation  (1,1) double
    loc       (1,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    ori       (1,3) double % [Heading, Tilt, Roll] (+-360 deg)
    delay     (1,1) double = 0.0
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:AnimatedUpdate>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>", dulation)];
kmlstr = [kmlstr; sprintf("<Update>")];
kmlstr = [kmlstr; sprintf("<Change>")];

% Location update
kmlstr = [kmlstr; sprintf("<Location targetId=""%sLoc"">", modelname)];
kmlstr = [kmlstr; sprintf("<latitude>%.8f</latitude>", loc(1))];
kmlstr = [kmlstr; sprintf("<longitude>%.8f</longitude>", loc(2))];
kmlstr = [kmlstr; sprintf("<altitude>%.3f</altitude>", loc(3))];
kmlstr = [kmlstr; sprintf("</Location>")];

% Orientation update
kmlstr = [kmlstr; sprintf("<Orientation targetId=""%sOri"">", modelname)];
kmlstr = [kmlstr; sprintf("<heading>%.3f</heading>", ori(1))];
kmlstr = [kmlstr; sprintf("<tilt>%.3f</tilt>", ori(2))];
kmlstr = [kmlstr; sprintf("<roll>%.3f</roll>", ori(3))];
kmlstr = [kmlstr; sprintf("</Orientation>")];

kmlstr = [kmlstr; sprintf("</Change>")];
kmlstr = [kmlstr; sprintf("</Update>")];
kmlstr = [kmlstr; sprintf("<gx:delayedStart>%.3f</gx:delayedStart>", delay)];
kmlstr = [kmlstr; sprintf("</gx:AnimatedUpdate>")];