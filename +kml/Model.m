function kmlstr = Model(modelid, file, loc, ori, scale, altmode)
% Create placemark for Model
% Author: Taro Suzuki
arguments
    modelid (:,1) string
    file    (:,1) string
    loc     (:,3) double % [Latitude, Longitude, Altitude] (deg,deg,m)
    ori     (:,3) double % [Heading, Tilt, Roll] (+-360 deg)
    scale   (1,1) double = 1.0
    altmode (1,:) char {mustBeMember(altmode,{'clampToGround','relativeToGround','absolute'})} = 'clampToGround'
end
nmodel = length(modelid);
if size(ori,1)==1
    ori = repmat(ori, nmodel, 1);
end

kmlstr = [];
kmlmodels = [];
for i=1:nmodel
    kmlmodels = [kmlmodels; sprintf("<Placemark>")];
    kmlmodels = [kmlmodels; sprintf("<name>%s</name>", modelid(i))];
    
    kmlmodels = [kmlmodels; sprintf("<Model id=""%s"">", modelid(i))];
    
    kmlmodels = [kmlmodels; sprintf("<altitudeMode>%s</altitudeMode>", altmode)];
    
    kmlmodels = [kmlmodels; sprintf("<Location id=""%sLoc"">", modelid(i))];
    kmlmodels = [kmlmodels; sprintf("<latitude>%.8f</latitude>", loc(i,1))];
    kmlmodels = [kmlmodels; sprintf("<longitude>%.8f</longitude>", loc(i,2))];
    kmlmodels = [kmlmodels; sprintf("<altitude>%.3f</altitude>", loc(i,3))];
    kmlmodels = [kmlmodels; sprintf("</Location>")];
    
    kmlmodels = [kmlmodels; sprintf("<Orientation id=""%sOri"">", modelid(i))];
    kmlmodels = [kmlmodels; sprintf("<heading>%.3f</heading>", ori(i,1))];
    kmlmodels = [kmlmodels; sprintf("<tilt>%.3f</tilt>", ori(i,2))];
    kmlmodels = [kmlmodels; sprintf("<roll>%.3f</roll>", ori(i,3))];
    kmlmodels = [kmlmodels; sprintf("</Orientation>")];
    
    kmlmodels = [kmlmodels; sprintf("<Scale>")];
    kmlmodels = [kmlmodels; sprintf("<x>%.3f</x>", scale)];
    kmlmodels = [kmlmodels; sprintf("<y>%.3f</y>", scale)];
    kmlmodels = [kmlmodels; sprintf("<z>%.3f</z>", scale)];
    kmlmodels = [kmlmodels; sprintf("</Scale>")];
    
    kmlmodels = [kmlmodels; sprintf("<Link id=""%sLink"">", modelid(i))];
    kmlmodels = [kmlmodels; sprintf("<href>%s</href>", file(i))];
    kmlmodels = [kmlmodels; sprintf("</Link>")];
    
    kmlmodels = [kmlmodels; sprintf("</Model>")];
    
    kmlmodels = [kmlmodels; sprintf("</Placemark>")];
end
if nmodel>1
    kmlmodels = kml.WrapFolder(kmlmodels, "Models");
end
kmlstr = [kmlstr; kmlmodels];