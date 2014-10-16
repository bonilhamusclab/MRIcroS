function layerRGBA(v,varargin)
% inputs: layerNumber, Red, Green, Blue, Alpha
%MRIcroS('layerRGBA', 1, 0.9, 0, 0, 0.2) %set layer 1 to bright red (0.9) with 20% opacity
% --- set a Layer's color and transparency
if (length(varargin) < 2), return; end;
vIn = cell2mat(varargin);
v.vprefs.colors(vIn(1),1:(length(varargin)-1)) = vIn(2:length(varargin)); %change layer's red/green/blue/opacity 
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end layerRGBA()
