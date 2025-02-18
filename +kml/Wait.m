function kmlstr = Wait(duration)
arguments
    duration
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:Wait>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>",duration)];
kmlstr = [kmlstr; sprintf("</gx:Wait>")];
