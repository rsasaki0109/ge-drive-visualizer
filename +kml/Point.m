function kmlstr = Point(name,loc,scale,col,alpha,drawoder,altmode)
arguments
    name 
    loc 
    scale 
    col 
    alpha = 1.0
    drawoder = []
    altmode = "clampToGround"
end

npoint = size(loc,1);

if size(col,1)==1 && npoint>1
    col = repmat(col,npoint,1);
end
chex = kml.col2hex(col,alpha);

if isempty(drawoder)
    drawoder = 1:npoint;
end

icon = "http://maps.google.com/mapfiles/kml/pal2/icon18.png";
kmlstr = [];

for i=1:npoint
    kmlstr = [kmlstr; sprintf("<Style id=""S%04d"">",i)];
    kmlstr = [kmlstr; sprintf("<IconStyle id=""IS%04d"">",i)];
    kmlstr = [kmlstr; sprintf("<color>%s</color>",chex(i,:))];
    kmlstr = [kmlstr; sprintf("<scale>%.1f</scale>",scale)];
    kmlstr = [kmlstr; sprintf("<Icon><href>%s</href></Icon>",icon)];
    kmlstr = [kmlstr; sprintf("</IconStyle>")];
    kmlstr = [kmlstr; sprintf("</Style>")];
end

kmlstr = [kmlstr; sprintf("<Folder>")];
kmlstr = [kmlstr; sprintf("<name>%s</name>",name)];
for i=1:npoint
    kmlstr = [kmlstr; sprintf("<Placemark>")];
    kmlstr = [kmlstr; sprintf("<styleUrl>#S%04d</styleUrl>",i)];
    kmlstr = [kmlstr; sprintf("<Point id=""P%04d"">",i)];
    kmlstr = [kmlstr; sprintf("<altitudeMode>%s</altitudeMode>",altmode)];
    kmlstr = [kmlstr; sprintf("<coordinates>%.8f,%.8f,%.3f</coordinates>",loc(i,2),loc(i,1),loc(i,3))];
    kmlstr = [kmlstr; sprintf("<gx:drawOrder>%d</gx:drawOrder>",drawoder(i))];
    kmlstr = [kmlstr; sprintf("</Point>")];
    kmlstr = [kmlstr; sprintf("</Placemark>")];
end
kmlstr = [kmlstr; sprintf("</Folder>")];