function hideWireframe(v, layer)
% inputs: layerNumber
%MRIcroS('hideWireframe', 1) %hide wireframe from layer 1

v.vprefs.showEdges(layer) = 0;

guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
