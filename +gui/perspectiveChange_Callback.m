function perspectiveChange_Callback(obj,evd)
% --- reposition light after camera is moved, store new camera azimuth/elevation
v=guidata(obj);
camlight(v.vprefs.camLight, 0,40);
guidata(v.hMainFigure,v);%store settings


return; %CRX - DISABLE - LOTS OF FLICKER
v=guidata(obj);
%camlight(v.vprefs.camLight, v.vprefs.azLight,v.vprefs.elLight);
camlight(v.vprefs.camLight, 'headlight');
newView = round(get(evd.Axes,'View'));
v.vprefs.az = newView(1);
v.vprefs.el = newView(2);
guidata(v.hMainFigure,v);%store settings
%end mypostcallback()
