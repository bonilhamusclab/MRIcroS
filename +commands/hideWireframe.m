function hideWireframe(v, layer)
% inputs: layerNumber
% note: rgb can not be a string such as 'blue', must be an array
%MRIcroS('layerRGBA', 1, [1 0, 0]) %set layer 1 to red
%MRIcroS('layerRGBA', 1:2, [1 0, 0]) %set layer 1 & 2 to red

v.vprefs.showEdges(layer) = 0;

guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
