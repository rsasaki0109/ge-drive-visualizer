function Out(fname, kmlstr, kmlname)
% Output KML file
% Author: Taro Suzuki
arguments
    fname   (1,:) char
    kmlstr  (:,1) string
    kmlname (1,:) char = fname
end

str = ["<?xml version=""1.0"" encoding=""UTF-8""?>";
       "<kml xmlns=""http://www.opengis.net/kml/2.2"" xmlns:gx=""http://www.google.com/kml/ext/2.2"">";
       "<Document>";
       "<name>"+kmlname+"</name>"];
writelines(str, fname);

writelines(kmlstr, kmlname,"WriteMode","append");

str = ["</Document>";
       "</kml>"];
writelines(str, kmlname,"WriteMode","append");