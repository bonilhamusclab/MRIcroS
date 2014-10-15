function closeProjections(v, surfaceIndex)
%MRIcroS('closeProjections', surfaceIndex);
%MRIcroS('closeProjections');
%if no surface index specified, closes projections on all surfaces

if(nargin < 2)
    startIndex = 1;
    endIndex = length(v.surface);
else
    startIndex = surfaceIndex;
	endIndex = surfaceIndex;
end

for i = startIndex:endIndex
	v.surface(i).colorVertices = 0;
end

drawing.redrawSurface(v);

end
