function setView(v,varargin)
% --- set view by moving camera position
%MRIcroS('setView', 15, 25);
% inputs: azimuth(0..360), elevation(=90..90)
if (nargin < 1), return; end;
vIn = cell2mat(varargin);
v.vprefs.az = vIn(1);
if (nargin > 1), v.vprefs.el = vIn(2); end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end setView()
