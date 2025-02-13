function kmlstr = Line(name,loc,lwidth,col,alpha,draworder,altmode)
arguments
    name 
    loc 
    lwidth 
    col
    alpha = 1.0
    draworder = 0
    altmode = "clampToGround"
end
chex = kml.col2hex(col,alpha);

kmlstr = [];
kmlstr = [kmlstr; sprintf("<Placemark>")];
kmlstr = [kmlstr; sprintf("<name>%s</name>",name)];

kmlstr = [kmlstr; sprintf("<Style>")];
kmlstr = [kmlstr; sprintf("<LineStyle>")];
kmlstr = [kmlstr; sprintf("<color>%s</color>",chex)];
kmlstr = [kmlstr; sprintf("<width>%.1f</width>",lwidth)];
kmlstr = [kmlstr; sprintf("</LineStyle>")];
kmlstr = [kmlstr; sprintf("</Style>")];
kmlstr = [kmlstr; sprintf("<LineString>")];
kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>",altmode)];
kmlstr = [kmlstr; sprintf("<gx:drawOrder>%d</gx:drawOrder>",draworder)];
kmlstr = [kmlstr; sprintf("<coordinates>")];
for i=1:size(loc,1)
    kmlstr = [kmlstr; sprintf("%.8f,%.8f,%.3f",loc(i,2),loc(i,1),loc(i,3))];
end
kmlstr = [kmlstr; sprintf("</coordinates>")];
kmlstr = [kmlstr; sprintf("</LineString>")];

kmlstr = [kmlstr; sprintf("</Placemark>")];