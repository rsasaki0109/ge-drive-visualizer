function kmlstr = Legend(legstr, linespecs, linewidth, fontsize)
arguments
    legstr string    % legend string, e.g. ["Test 1", "Test 2"]
    linespecs string % e.g. ["r-","b:"]
    linewidth (1,1) double = 3
    fontsize (1,1) double = 20
end
n = length(legstr);

f = figure; hold on;
for i=1:n
    plot(NaN, linespecs(i), LineWidth=linewidth);
end
legend(legstr, FontSize=fontsize, FontName="Helvetica", FontWeight="bold", LineWidth=1.5);
axis off
exportgraphics(f,"legend.png")
close(f);

im = imread("legend.png");
alpha = ones(size(im,1), size(im,2));
alpha(all(im==255,3)) = 0.85;
imwrite(im, "legend.png", Alpha=alpha);

kmlstr = kml.ScreenOverlay("legend", "legend.png");