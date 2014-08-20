function addPial(v,filename)
%function addPial(v,filename)
	[faces, vertices] = fileUtils.pial.readPial(filename);
	brainSurface = drawing.plotFacesAndVertices(faces, vertices);

	hasSurface = isfield(v,'surface');
	surfaceIndex = 1;
	if(hasSurface) surfaceIndex = surfaceIndex + length(v.surface); end
	v.surface(surfaceIndex) = brainSurface;
	guidata(v.hMainFigure, v);
	v = drawing.removeDemoObjects(v);
    guidata(v.hMainFigure, v);