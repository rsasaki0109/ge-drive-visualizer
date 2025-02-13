function kmlstr = AnimatedUpdate(modelid,dulation,loc,ori)
arguments
    modelid 
    dulation 
    loc 
    ori 
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:AnimatedUpdate>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>",dulation)];
kmlstr = [kmlstr; sprintf("<Update>")];
kmlstr = [kmlstr; sprintf("<Change>")];

kmlstr = [kmlstr; sprintf("<Location targetId=""%sLoc"">",modelid)];
kmlstr = [kmlstr; sprintf("<latitude>%.8f</latitude>",loc(1))];
kmlstr = [kmlstr; sprintf("<longitude>%.8f</longitude>",loc(2))];
kmlstr = [kmlstr; sprintf("<altitude>%.3f</altitude>",loc(3))];
kmlstr = [kmlstr; sprintf("</Location>")];

kmlstr = [kmlstr; sprintf("<Orientation targetId=""%sOri"">",modelid)];
kmlstr = [kmlstr; sprintf("<heading>%.3f</heading>",ori(1))];
kmlstr = [kmlstr; sprintf("<tilt>%.3f</tilt>",ori(2))];
kmlstr = [kmlstr; sprintf("<roll>%.3f</roll>",ori(3))];
kmlstr = [kmlstr; sprintf("</Orientation>")];

kmlstr = [kmlstr; sprintf("</Change>")];
kmlstr = [kmlstr; sprintf("</Update>")];
kmlstr = [kmlstr; sprintf("</gx:AnimatedUpdate>")];