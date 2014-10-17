function hideWireframe(v, layer)
%function hideWireframe(v, layer)
% inputs: layer - layerNumber to remove wireframe from

v.vprefs.showEdges(layer) = 0;

v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings
