function layerRGBA(v,varargin)
% inputs: layerNumber, Red, Green, Blue, Alpha
%MRIcroS('layerRGBA', 1, 0.9, 0, 0, 0.2) %set layer 1 to bright red (0.9) with 20% opacity
% --- set a Layer's color and transparency
if (length(varargin) < 2), return; end;
layer = 1;
if (length(varargin) >= 1) && isnumeric(varargin{1}), layer = varargin{1}; end;
if layer > length(v.surface), return; end;
if (length(varargin) >= 2) && isnumeric(varargin{2}), v.vprefs.colors(layer,1) = varargin{2}; end;
if (length(varargin) >= 3) && isnumeric(varargin{3}), v.vprefs.colors(layer,2) = varargin{3}; end;
if (length(varargin) >= 4) && isnumeric(varargin{4}), v.vprefs.colors(layer,3) = varargin{4};end;
if (length(varargin) >= 5) && isnumeric(varargin{5}), v.vprefs.colors(layer,4) = varargin{5};end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end layerRGBA()
