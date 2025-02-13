function kmlstr = Point(name,loc,scale,col,alpha,altmode)
arguments
    name 
    loc 
    scale 
    col 
    alpha = 1.0
    altmode = "clampToGround"
end
chex = kml.col2hex(col,alpha);

icon = "http://maps.google.com/mapfiles/kml/pal2/icon18.png";
kmlstr = [];

kmlstr = [kmlstr; sprintf("<Style id=""P1"">")];
kmlstr = [kmlstr; sprintf("<IconStyle>")];
kmlstr = [kmlstr; sprintf("<color>%s</color>",chex)];
kmlstr = [kmlstr; sprintf("<scale>%.1f</scale>",scale)];
kmlstr = [kmlstr; sprintf("<Icon><href>%s</href></Icon>",icon)];
kmlstr = [kmlstr; sprintf("</IconStyle>")];
kmlstr = [kmlstr; sprintf("</Style>")];

kmlstr = [kmlstr; sprintf("<Folder>")];
kmlstr = [kmlstr; sprintf("<name>Points</name>")];
for i=1:size(loc,1)
    kmlstr = [kmlstr; sprintf("<Placemark>")];
    kmlstr = [kmlstr; sprintf("<styleUrl>#P1</styleUrl>")];
    kmlstr = [kmlstr; sprintf("<Point>")];
    kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>",altmode)];
    kmlstr = [kmlstr; sprintf("<coordinates>%.8f,%.8f,%.3f</coordinates>",loc(i,2),loc(i,1),loc(i,3))];
    kmlstr = [kmlstr; sprintf("</Point>")];
    kmlstr = [kmlstr; sprintf("</Placemark>")];
end
kmlstr = [kmlstr; sprintf("</Folder>")];