function showWireFrame(v, layer, show, rgb)
% inputs: layerNumber, show, rgb array
% note: rgb can not be a string such as 'blue', must be an array
%MRIcroS('layerRgba', 1, [1 0, 0]) %set layer 1 to red
%MRIcroS('layerRgba', 1:2, [1 0, 0]) %set layer 1 & 2 to red
if(nargin == 4 && ~show)
    rgb = v.vprefs.edgeColors(layer,:);
end

v.vprefs.edgeColors(layer, :) = rgb;
v.vprefs.showEdges(layer) = show;

guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);