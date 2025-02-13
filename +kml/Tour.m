function kmlstr = Tour(kmlstr,name)
arguments
    kmlstr 
    name
end

head = [];
head = [head; sprintf("<gx:Tour>")];
head = [head; sprintf("<name>%s</name>",name)];
head = [head; sprintf("<gx:Playlist>")];

foot = [];
foot = [foot; sprintf("</gx:Playlist>")];
foot = [foot; sprintf("</gx:Tour>")];

kmlstr = [head; kmlstr; foot];