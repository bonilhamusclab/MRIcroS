function closeProjections(v, surfaceIndex)
%MRIcroS('closeProjections', surfaceIndex);
%MRIcroS('closeProjections');
%if no surface index specified, closes projections on all surfaces

v = guidata(v.hMainFigure);

if(nargin < 2)
    startIndex = 1;
    endIndex = length(v.surface);
else
    startIndex = surfaceIndex;
	endIndex = surfaceIndex;
end

for i = startIndex:endIndex
	v.surface(i).vertexColors = [];
end

v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings

end
