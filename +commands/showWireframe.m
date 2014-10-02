function showWireframe(v, layer, rgb)
% inputs: layerNumber, show, rgb array
% note: rgb can not be a string such as 'blue', must be an array
%MRIcroS('layerRgba', 1, [1 0, 0]) %set layer 1 to red
%MRIcroS('layerRgba', 1:2, [1 0, 0]) %set layer 1 & 2 to red
if(nargin == 2)
    rgb = v.vprefs.edgeColors(layer,:);
end

v.vprefs.edgeColors(layer, 1:3) = rgb;
v.vprefs.showEdges(layer) = 1;

guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);