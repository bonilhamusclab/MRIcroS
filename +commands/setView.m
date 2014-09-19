function setView(v,varargin)
% inputs: azimuth(0..360), elevation(=90..90)
%MATcro('setView', 15, 25);
% --- set view by moving camera position
if (nargin < 1), return; end;
vIn = cell2mat(varargin);
v.vprefs.az = vIn(1);
if (nargin > 1), v.vprefs.el = vIn(2); end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end setView()
