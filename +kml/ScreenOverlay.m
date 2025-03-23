function kmlstr = ScreenOverlay(screenid, file)
% Create ScreenOverlay
% Author: Taro Suzuki
arguments
    screenid (1,:) string
    file     (1,:) string
end

kmlstr = [];
kmlstr = [kmlstr; sprintf("<ScreenOverlay id=""SO%s"">", screenid)];
kmlstr = [kmlstr; sprintf("<name>%s</name>", screenid)];
kmlstr = [kmlstr; sprintf("<Icon>")];
kmlstr = [kmlstr; sprintf("<href>%s</href>", file)];
kmlstr = [kmlstr; sprintf("</Icon>")];
kmlstr = [kmlstr; sprintf("<overlayXY x=""0.99"" y=""0.99"" xunits=""fraction"" yunits=""fraction""/>")];
kmlstr = [kmlstr; sprintf("<screenXY x=""0.99"" y=""0.99"" xunits=""fraction"" yunits=""fraction""/>")];
kmlstr = [kmlstr; sprintf("<rotation>0</rotation>")];
kmlstr = [kmlstr; sprintf("<size x=""0"" y=""0"" xunits=""pixels"" yunits=""pixels""/>")];
kmlstr = [kmlstr; sprintf("</ScreenOverlay>")];