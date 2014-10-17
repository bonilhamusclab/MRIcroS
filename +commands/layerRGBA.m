function layerRGBA(v,layerNumber, varargin)
%function layerRGBA(v,layerNumber, varargin)
% inputs: layerNumber, Red, Green, Blue, Alpha, Contrast
%  layerNumber : layer to apply changes
%  r (optional): red value 0..1, ignored for vertex colors
%  g (optional): green value 0..1, ignored for vertex colors
%  b (optional): blue value 0..1, ignored for vertex colors
%  a (optional): opacity/alpha value 0..1, 
%  contrast (optional): contrast value 0..1 adjust vertex color bias - only for vertex colors
%MRIcroS('layerRGBA', 1, 'r', 0.9, 'g', 0, 'b', 0, 'a', 0.2) %set layer 1 to bright red (0.9) with 20% opacity
% --- set a Layer's color and transparency


color = v.vprefs.colors(layerNumber,:);
p = createInputParserSub(color);
parse(p, varargin{:});

v.vprefs.colors(layerNumber,:) = [p.Results.r, p.Results.g, p.Results.b, p.Results.a];

contrastSet = ~isempty(p.UsingDefaults) && sum(strcmp(p.UsingDefaults, 'contrast'));

if (numel(v.surface(layerNumber).vertexColors) > 1) && contrastSet %adjust contrast for objects with vertex colors 
    contrast = p.Results.contrast;
    if  (contrast ~= 0.5) && (contrast <= 1) && (contrast >= 0)
        % Perlin & Hoffert's bias function http://blog.demofox.org/2012/09/24/bias-and-gain-are-your-friend/
        if (contrast == 1), contrast = 1 - eps; end;
        if (contrast == 0), contrast = eps; end;
        vc = v.surface(layerNumber).vertexColors;
        v.surface(layerNumber).vertexColors = (vc ./ ((((1.0 ./contrast) - 2.0) .*(1.0 - vc))+1.0));
    end
end
v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings
%end layerRGBA()

function p = createInputParserSub(color)
p = inputParser;
r = color(1); g = color(2); b = color(3); a = color(4);
p.addParameter('r',r,@(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));
p.addParameter('g',r,@(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));
p.addParameter('b',r,@(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));
p.addParameter('a',r,@(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));
p.addParameter('contrast',r,@(x) validateattributes(x, {'numeric'}, {'>=',0,'<=',1}));