function kmlstr = FlyTo(kmlstr,duration,mode)
arguments
    kmlstr 
    duration = 0.0
    mode = "smooth"
end

head = [];
head = [head; sprintf("<gx:FlyTo>")];
head = [head; sprintf("<gx:duration>%.3f</gx:duration>",duration)];
head = [head; sprintf("<gx:flyToMode>%s</gx:flyToMode>",mode)];

foot = [];
foot = [foot; sprintf("</gx:FlyTo>")];

kmlstr = [head; kmlstr; foot];