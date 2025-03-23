function kmlstr = WrapFolder(kmlstr, name)
% Wrap with Folder tag
% Author: Taro Suzuki
arguments
    kmlstr (:,1) string
    name   (1,:) char
end

head = [];
head = [head; sprintf("<Folder>")];
head = [head; sprintf("<name>%s</name>", name)];

foot = [];
foot = [foot; sprintf("</Folder>")];

kmlstr = [head; kmlstr; foot];