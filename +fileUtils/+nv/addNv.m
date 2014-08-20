function addNv(v,filename)
%function addNv(v,filename)
	[faces, vertices] = fileUtils.nv.readNv(filename);
	brainSurface = drawing.plotFacesAndVertices(faces, vertices);

	hasSurface = isfield(v,'surface');
	surfaceIndex = 1;
	if(hasSurface) surfaceIndex = surfaceIndex + length(v.surface); end
	v.surface(surfaceIndex) = brainSurface;
	guidata(v.hMainFigure, v);
	v = drawing.removeDemoObjects(v);
    guidata(v.hMainFigure, v);