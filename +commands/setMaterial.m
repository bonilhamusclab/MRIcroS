function setMaterial(v,varargin)
% inputs: ambient(0..1), diffuse(0..1), specular(0..1), specularExponent(0..inf), bgMode (0 or 1), backFaceLighting (0 or 1)
%MRIcroS('setMaterial', 0.5, 0.5, 0.7, 100, 1, 1);
% --- set surface appearance (shiny, matte, etc)
if (length(varargin) < 1), return; end;
vIn = cell2mat(varargin);
v.vprefs.materialKaKdKsn(1) = vIn(1);
if (length(varargin) > 1), v.vprefs.materialKaKdKsn(2) = vIn(2); end;
if (length(varargin) > 2), v.vprefs.materialKaKdKsn(3) = vIn(3); end;
v.vprefs.materialKaKdKsn(1:3) = boundArray(v.vprefs.materialKaKdKsn(1:3),0,1);
if (length(varargin) > 3), v.vprefs.materialKaKdKsn(4) = vIn(4); end;
if (length(varargin) > 4), v.vprefs.bgMode = vIn(5); end;
if (length(varargin) > 5), v.vprefs.backFaceLighting = vIn(6); end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end setMaterial()
