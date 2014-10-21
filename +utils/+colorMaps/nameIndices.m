function indices = nameIndices(names)
%function indices = nameIndices(names)
%specify no names to retrieve all colorMap indices
%returns 0 for names not found
colorMaps = utils.colorMaps.names();

if nargin < 1
    indices = 1: length(colorMaps);
else	
	if ~iscell(names)
		names = {names};
	end
	numNames = length(names);
    indices = zeros(1, numNames);
    for i = 1:numNames
        name = names{i};
        index = find(strcmpi(colorMaps, name));
        if isempty(index)
            index = 0;
        end
        indices(i) = index;
    end
end
