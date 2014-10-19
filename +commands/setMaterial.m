function setMaterial(v,varargin)
% inputs: ambient(0..1), diffuse(0..1), specular(0..1), specularExponent(0..inf), backFaceLighting (0 or 1)
%MRIcroS('setMaterial', 0.5, 0.5, 0.7, 100, 1);
% --- set surface appearance (shiny, matte, etc)
if (length(varargin) < 1), return; end;
if (length(varargin) >= 1) && isnumeric(varargin{1}), v.vprefs.materialKaKdKsn(1) = varargin{1}; end;
if (length(varargin) >= 2) && isnumeric(varargin{2}), v.vprefs.materialKaKdKsn(2) = varargin{2}; end;
if (length(varargin) >= 3) && isnumeric(varargin{3}), v.vprefs.materialKaKdKsn(3) = varargin{3}; end;
if (length(varargin) >= 4) && isnumeric(varargin{4}), v.vprefs.materialKaKdKsn(4) = varargin{4};end;
if (length(varargin) >= 5) && isnumeric(varargin{5}), v.vprefs.backFaceLighting = varargin{5};end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end setMaterial()
