function showWireframe(v, layer, rgba)
%function showWireframe(v, layer, rgba)
% inputs: 
%   layerNumber, 
%   rgba array - optional, defaults to [0 0 0 1]
%   alhpa set as 1 if not specified, [0 0 0] same as [0 0 0 1]
% note: rgb can not be a string such as 'blue', must be an array
%MRIcroS('layerRGBA', 1, [1 0 0]) %set layer 1 to red
%MRIcroS('layerRGBA', 1:2, [1 0 0]) %set layer 1 & 2 to red
%MRIcroS('layerRGBA', 1, [0 0 0 .1]) %set layer 1 to black with .1 alpha
if(nargin < 3)
    rgba = [0 0 0 1];
end

if(length(rgba) == 3)
    rgba(4) = 1;
end

validateattributes(rgba, {'numeric'}, {'<=',1, '>=', 0, 'numel', 4});

v.vprefs.edgeColors(layer, :) = rgba;
v.vprefs.showEdges(layer) = 1;

v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings