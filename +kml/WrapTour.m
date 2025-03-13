function kmlstr = WrapTour(kmlstr, name)
% Wrap with Tour tag
% Author: Taro Suzuki
arguments
    kmlstr (:,1) string
    name   (1,:) char
end

head = [];
head = [head; sprintf("<gx:Tour>")];
head = [head; sprintf("<name>%s</name>", name)];
head = [head; sprintf("<gx:Playlist>")];

foot = [];
foot = [foot; sprintf("</gx:Playlist>")];
foot = [foot; sprintf("</gx:Tour>")];

kmlstr = [head; kmlstr; foot];