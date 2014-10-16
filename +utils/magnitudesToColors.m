function colors = magnitudesToColors(magnitudes, clrMap)
%function colors = magnitudesToColors(magnitudes, clrMap)
%convert Mx1 magnitudes into RGB Mx3 colors using desired colormap
%note: expcets magnitudes to be from 0 to 1
resolution = 64;

clrMap = str2func(clrMap);
clr = clrMap(resolution);

colors = ind2rgb(round(magnitudes(:) * 63)+1 ,clr);
colors= reshape(colors,numel(magnitudes),3);
%end magnitudesToColors()
