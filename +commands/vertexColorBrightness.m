function vertexColorBrightness(v,layer, brightness, varargin)
%Use Perlin & Hoffert's bias function to adjust brightness (only for meshes with vertex colors)
% see http://blog.demofox.org/2012/09/24/bias-and-gain-are-your-friend/
% layer: mesh for adjustment
% brightness : 0.5 means no change, smaller value means darker
% alpha: opacity
% colormap: 'gray','autumn','cool'... or 1,2,3...
% colormin: in range 0..1, values dark than this value are displayed at this threshold
%MRIcroS('vertexColorBrightness', 1, .7) %increase brightness on layer 1
% --- set a Layer's color and transparency

if isempty(v.surface(layer).vertexColors)
    fprintf('%s is for layers with vertex colors', mfilename);
    return;
end;

alpha = v.vprefs.colors(layer,4);
colorMap = v.surface(layer).colorMap;
colorMap = utils.colorTables(colorMap); %text name
colorMin = v.surface(layer).colorMin;
colorMin = utils.boundArray(colorMin,0,0.95);

if (length(varargin) >= 1) && isnumeric(varargin{1}), alpha = varargin{1}; end;
if length(varargin) >= 2
    colorMap = varargin{2}; 
    colorMap = utils.colorTables(colorMap); %ensure text name
end;
if (length(varargin) >= 3) && isnumeric(varargin{3})
    colorMin = varargin{3}; 
    colorMin = utils.boundArray(colorMin,0,0.95); %ensure in range
end;

v.surface(layer).colorMap = colorMap;
v.surface(layer).colorMin = colorMin;
v.vprefs.colors(layer,4) = alpha;
if (numel(v.surface(layer).vertexColors) > 0) && (brightness ~= 0.5)
    if (brightness >= 1), brightness = 1 - eps; end;
    if (brightness <= 0), brightness = eps; end;
    vc = v.surface(layer).vertexColors;
    v.surface(layer).vertexColors = (vc ./ ((((1.0 ./brightness) - 2.0) .*(1.0 - vc))+1.0));
end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end vertexColorBrightness()
