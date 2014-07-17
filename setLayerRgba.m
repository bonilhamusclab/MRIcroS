% --- set a Layer's color and transparency
function setLayerRgba(v,varargin)
% inputs: layerNumber, Red, Green, Blue, Alpha
%MATcro('layerRGBA', 1, 0.9, 0, 0, 0.2) %set layer 1 to bright red (0.9) with 20% opacity
if (length(varargin) < 2), return; end;
vIn = cell2mat(varargin);
v.vprefs.colors(vIn(1),1:(length(varargin)-1)) = vIn(2:length(varargin)); %change layer 1's red/green/blue/opacity 
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end setLayerRgba()
