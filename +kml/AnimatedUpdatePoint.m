function kmlstr = AnimatedUpdatePoint(pointid,dulation,loc,delay,col,alpha,draworder)
arguments
    pointid 
    dulation 
    loc
    delay = 0.0
    col = []
    alpha = []
    draworder = []
end

if size(pointid,1) < size(pointid,2)
    pointid = pointid';
end
pointid = string(num2str(pointid,"%04d"));
npoint = length(pointid);

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:AnimatedUpdate>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>",dulation)];
kmlstr = [kmlstr; sprintf("<Update>")];
kmlstr = [kmlstr; sprintf("<Change>")];

if ~isempty(col)
    if size(col,1)==1 && npoint>1
        col = repmat(col,npoint,1);
    end
    chex = kml.col2hex(col,alpha);
end

for i=1:npoint
    kmlstr = [kmlstr; sprintf("<Point targetId=""P%s"">",pointid(i))];
    kmlstr = [kmlstr; sprintf("<coordinates>%.8f,%.8f,%.3f</coordinates>",loc(i,2),loc(i,1),loc(i,3))];
    kmlstr = [kmlstr; sprintf("</Point>")];

    if ~isempty(col)
        kmlstr = [kmlstr; sprintf("<IconStyle targetId=""IS%s"">",pointid(i))];
        kmlstr = [kmlstr; sprintf("<color>%s</color>",chex(i,:))];
        kmlstr = [kmlstr; sprintf("</IconStyle>")];
    end

    if ~isempty(draworder)
        kmlstr = [kmlstr; sprintf("<Point targetId=""P%s"">",pointid(i))];
        kmlstr = [kmlstr; sprintf("<gx:drawOrder>%d</gx:drawOrder>",draworder(i))];
        kmlstr = [kmlstr; sprintf("</Point>")];
    end
end

kmlstr = [kmlstr; sprintf("</Change>")];
kmlstr = [kmlstr; sprintf("</Update>")];
kmlstr = [kmlstr; sprintf("<gx:delayedStart>%.3f</gx:delayedStart>",delay)];
kmlstr = [kmlstr; sprintf("</gx:AnimatedUpdate>")];