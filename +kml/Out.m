function Out(fname, kmlstr, kmlname)
% Output KML file
% Author: Taro Suzuki
arguments
    fname   (1,:) char
    kmlstr  (:,1) string 
    kmlname (1,:) char = fname
end

fid = fopen(fname, "w");
fprintf(fid,"<?xml version=""1.0"" encoding=""UTF-8""?>\n");
fprintf(fid,"<kml xmlns=""http://www.opengis.net/kml/2.2"" xmlns:gx=""http://www.google.com/kml/ext/2.2"">\n");
fprintf(fid,"<Document>\n");
fprintf(fid,"<name>%s</name>\n", kmlname);

for i=1:size(kmlstr,1)
    fprintf(fid,"%s\n", kmlstr(i));
end

fprintf(fid,"</Document>\n");
fprintf(fid,"</kml>\n");
fclose(fid);