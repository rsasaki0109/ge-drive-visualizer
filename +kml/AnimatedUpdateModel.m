function kmlstr = AnimatedUpdateModel(modelid, dulation, loc, ori, file, delay)
% Create AnimatedUpdate for Model
% Author: Taro Suzuki
arguments
    modelid  (:,1) string
    dulation (1,1) double
    loc      (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    ori      (:,3) double = [] % [Heading, Tilt, Roll] (+-360 deg)
    file     (:,1) string = []
    delay    (1,1) double = 0.0
end
nmodel = length(modelid);

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:AnimatedUpdate>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>", dulation)];
kmlstr = [kmlstr; sprintf("<Update>")];
kmlstr = [kmlstr; sprintf("<Change>")];

for i=1:nmodel
    % Location update
    kmlstr = [kmlstr; sprintf("<Location targetId=""%sLoc"">", modelid(i))];
    kmlstr = [kmlstr; sprintf("<latitude>%.8f</latitude>", loc(i,1))];
    kmlstr = [kmlstr; sprintf("<longitude>%.8f</longitude>", loc(i,2))];
    kmlstr = [kmlstr; sprintf("<altitude>%.3f</altitude>", loc(i,3))];
    kmlstr = [kmlstr; sprintf("</Location>")];
    
    % Orientation update
    if ~isempty(ori)
        kmlstr = [kmlstr; sprintf("<Orientation targetId=""%sOri"">", modelid(i))];
        kmlstr = [kmlstr; sprintf("<heading>%.3f</heading>", ori(i,1))];
        kmlstr = [kmlstr; sprintf("<tilt>%.3f</tilt>", ori(i,2))];
        kmlstr = [kmlstr; sprintf("<roll>%.3f</roll>", ori(i,3))];
        kmlstr = [kmlstr; sprintf("</Orientation>")];
    end
    
    % Link update
    if ~isempty(file)
        kmlstr = [kmlstr; sprintf("<Link targetId=""%sLink"">", modelid(i))];
        kmlstr = [kmlstr; sprintf("<href>%s</href>", file(i))];
        kmlstr = [kmlstr; sprintf("</Link>")];
    end
end

kmlstr = [kmlstr; sprintf("</Change>")];
kmlstr = [kmlstr; sprintf("</Update>")];
kmlstr = [kmlstr; sprintf("<gx:delayedStart>%.3f</gx:delayedStart>", delay)];
kmlstr = [kmlstr; sprintf("</gx:AnimatedUpdate>")];