function kmlstr = Wait(duration)
% Create Wait
% Author: Taro Suzuki
arguments
    duration (1,1) double
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<gx:Wait>")];
kmlstr = [kmlstr; sprintf("<gx:duration>%.3f</gx:duration>", duration)];
kmlstr = [kmlstr; sprintf("</gx:Wait>")];
