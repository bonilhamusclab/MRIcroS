function colors = magnitudeToColor(magnitudes, clrMap)
%function colors = magnitudeToColor(magnitudes, clrMap)
%convert Mx1 magnitudes into RGB Mx3 colors using desired colormap
resolution = 64;

clrMap = str2func(clrMap);
clr = clrMap(resolution);

colors = ind2rgb(round(magnitudes(:) * 63)+1 ,clr);
colors= reshape(colors,numel(magnitudes),3);
%end magnitudeToColor()
