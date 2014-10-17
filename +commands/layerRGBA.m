function layerRGBA(v,varargin)
% inputs: layerNumber, Red, Green, Blue, Alpha, Contrast
%  layerNumber : layer to apply changes
%  Red: red value 0..1, ignored for vertex colors
%  Green: green value 0..1, ignored for vertex colors
%  Blue: blue value 0..1, ignored for vertex colors
%  Alpha: opacity value 0..1, 
%  Contrast: (optional) value 0..1 adjust vertex color bias - only for vertex colors
%MRIcroS('layerRGBA', 1, 0.9, 0, 0, 0.2) %set layer 1 to bright red (0.9) with 20% opacity
% --- set a Layer's color and transparency
if (length(varargin) < 2), return; end;

vIn = cell2mat(varargin);
layer = vIn(1); 
nColors = length(varargin)-1;
if (nColors > 4), nColors = 4; end;
v.vprefs.colors(layer,1:nColors) = vIn(2:nColors+1); %change layer's red/green/blue/opacity 
if (numel(v.surface(layer).vertexColors) > 1) && (length(varargin) > 5) %adjust contrast for objects with vertex colors 
    contrast = vIn(6);
    if  (contrast ~= 0.5) && (contrast <= 1) && (contrast >= 0)
        % Perlin & Hoffert's bias function http://blog.demofox.org/2012/09/24/bias-and-gain-are-your-friend/
        if (contrast == 1), contrast = 1 - eps; end;
        if (contrast == 0), contrast = eps; end;
        vc = v.surface(layer).vertexColors;
        v.surface(layer).vertexColors = (vc ./ ((((1.0 ./contrast) - 2.0) .*(1.0 - vc))+1.0));
    end
end
v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings
%end layerRGBA()
