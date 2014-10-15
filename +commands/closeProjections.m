function closeProjections(v, surfaceIndex)
%MRIcroS('closeProjections', surfaceIndex);
%surface index defaults to 1 if not specified

if(nargin == 1)
    surfaceIndex = 1;
end

v.surface(surfaceIndex).colorVertices = 0;

drawing.redrawSurface(v);

end