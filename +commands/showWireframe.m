function showWireframe(v, layer, rgb, alpha)
% inputs: 
%   layerNumber, 
%   rgb array - optional, defaults to [0 0 0]
%   alpha - optional, defaults to 1
% note: rgb can not be a string such as 'blue', must be an array
% note 2: use '' or [] to specify default for input
%MRIcroS('layerRGBA', 1, [1 0 0]) %set layer 1 to red
%MRIcroS('layerRGBA', 1:2, [1 0 0]) %set layer 1 & 2 to red
%MRIcroS('layerRGBA', 1, '', .1) %set layer 1 to black with .1 alpha
if(nargin < 3)
    rgb = [0 0 0];
end

if(nargin < 4)
    alpha = 1;
end

v.vprefs.edgeColors(layer, 1:3) = rgb;
v.vprefs.edgeColors(layer, 4) = alpha;
v.vprefs.showEdges(layer) = 1;

v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings
