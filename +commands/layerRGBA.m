function layerRGBA(v,layer, varargin)
%function layerRGBA(v,layer, varargin)
% inputs: 
% 1) layer, '' set to layer 1
% Optional Inputs
%   defaults to current rgba values for the layer if not specified
% 2) r (Red)
% 3) g (Green)
% 4) b (Blue)
% 5) a (Alpha)
%MRIcroS('layerRGBA', 1, 0.9, 0, 0, 0.2) %set layer 1 to bright red (0.9) with 20% opacity
% --- set a Layer's color and transparency

if isempty(layer)
    layer = 1;
end

numLayers = length(v.surface);

validateattributes(layer, {'numeric'}, {'>=', 1, '<=', numLayers, 'integer'});

[color, alph] = drawing.utils.currentLayerRGBA(layer, v.vprefs.colors);

rgba = parseInputs([color alph], varargin);

v.vprefs.colors(layer,:) = rgba;

guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end layerRGBA()

function rgba = parseInputs(color, args)
p = inputParser;
d.r = color(1); d.g = color(2); d.b = color(3); d.a = color(4);

p.addOptional('r',d.r, ...
    @(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));
p.addOptional('g',d.g, ...
    @(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));
p.addOptional('b',d.b, ...
    @(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));
p.addOptional('a',d.a, ...
    @(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));

p = utils.stringSafeParse(p, args, fieldnames(d), d.r, d.g, d.b, d.a);

inputParams = p.Results;

rgba = [inputParams.r, inputParams.g, inputParams.b, inputParams.a];