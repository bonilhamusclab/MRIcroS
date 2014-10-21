function name = names(indices)
%function name = names(indices)
%specify no indices to retrive all names
colorMaps = {'gray','autumn','bone','cool','copper','hot','hsv','jet','pink','winter'};

if nargin < 1
    indices = 1:length(colorMaps);
end

name = colorMaps(indices);