function colors = magnitudesToColors(magnitudes, clrMap, clrMin)
%function colors = magnitudesToColors(magnitudes, clrMap, clrMin)
%convert Mx1 magnitudes into RGB Mx3 colors using desired colormap
% magnitudes: vector of intensity 0..1
% clrMap: map for RGB transform ('gray', 'jet', etc)
% clrMin: 0..1. Magnitudes less than the value are set to this intensity
%note: expects magnitudes to be from 0 to 1

if (nargin >= 3) && isnumeric(clrMin) && (clrMin > 0)
    clrMin = utils.boundArray(clrMin,0,0.95);
    magnitudes(magnitudes < clrMin) = clrMin;
end;
if ~isempty(clrMap) 
    clrMap = utils.colorTables(clrMap); %ensure a valid color table
end
if isempty(clrMap) || (strcmpi(clrMap, 'gray'))
    %default grayscale. Note that fore 'gray' we do not want to lose precision
    colors = [magnitudes(:) magnitudes(:) magnitudes(:)];
else
    resolution = 64;
    clrMap = str2func(clrMap);
    clr = clrMap(resolution);
    colors = ind2rgb(round(magnitudes(:) * 63)+1 ,clr);
    colors= reshape(colors,numel(magnitudes),3);
end
%end magnitudesToColors()
