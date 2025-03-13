function kmlstr = WrapFlyTo(kmlstr, duration, mode)
% Wrap with FlyTo tag
% Author: Taro Suzuki
arguments
    kmlstr   (:,:) char
    duration (1,1) double = 0.0
    mode     (1,:) char {mustBeMember(mode,{'smooth','bounce'})} = 'smooth'
end

head = [];
head = [head; sprintf("<gx:FlyTo>")];
head = [head; sprintf("<gx:duration>%.3f</gx:duration>", duration)];
head = [head; sprintf("<gx:flyToMode>%s</gx:flyToMode>", mode)];

foot = [];
foot = [foot; sprintf("</gx:FlyTo>")];

kmlstr = [head; kmlstr; foot];