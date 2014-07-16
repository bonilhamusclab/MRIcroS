% --- reposition light after camera is moved, store new camera azimuth/elevation
function myPost_Callback(obj,evd)
v=guidata(obj);
camlight(v.vprefs.camLight, v.vprefs.azLight,v.vprefs.elLight);
newView = round(get(evd.Axes,'View'));
v.vprefs.az = newView(1);
v.vprefs.el = newView(2);
guidata(v.hMainFigure,v);%store settings
%end mypostcallback()
