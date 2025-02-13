function kmlstr = LookAt(loc,cam,altmode)
arguments
    loc
    cam
    altmode = "relativeToGround"
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<LookAt>")];
kmlstr = [kmlstr; sprintf("<latitude>%.8f</latitude>",loc(1))];
kmlstr = [kmlstr; sprintf("<longitude>%.8f</longitude>",loc(2))];
kmlstr = [kmlstr; sprintf("<altitude>%.3f</altitude>",loc(3))];
kmlstr = [kmlstr; sprintf("<heading>%.3f</heading>",cam.head)];
kmlstr = [kmlstr; sprintf("<tilt>%.3f</tilt>",cam.tilt)];
kmlstr = [kmlstr; sprintf("<range>%.3f</range>",cam.range)];
kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>",altmode)];
kmlstr = [kmlstr; sprintf("</LookAt>")];
