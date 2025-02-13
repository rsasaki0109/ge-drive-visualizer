function kmlstr = Placemark(kmlstr,name)
arguments
    kmlstr
    name
end

head = [];
head = [head; sprintf("<Placemark>")];
head = [head; sprintf("<name>%s</name>",name)];

foot = [];
foot = [foot; sprintf("</Placemark>")];

kmlstr = [head; kmlstr; foot];