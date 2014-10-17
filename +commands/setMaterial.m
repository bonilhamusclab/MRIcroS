function setMaterial(v,varargin)
% inputs: ambient(0..1), diffuse(0..1), specular(0..1), specularExponent(0..inf), backFaceLighting (0 or 1)
% if not specified, will use current values
%MRIcroS('setMaterial', 'ambient', 0.5);
% --- set surface appearance (shiny, matte, etc)
if (length(varargin) < 1), return; end;

p = createParserSub(v);
parse(p, varargin{:});

v.vprefs.materialKaKdKsn(1) = p.Results.ambient;
v.vprefs.materialKaKdKsn(2) = p.Results.diffuse;
v.vprefs.materialKaKdKsn(3) = p.Results.specular;
v.vprefs.materialKaKdKsn(4) = p.Results.specularExponent;
v.vprefs.backFaceLighting = p.Results.backFaceLighting;

v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings
%end setMaterial()

function p = createParserSub(v)
materialKaKdKsn = v.vprefs.materialKaKdKsn;
a = materialKaKdKsn(1);
d = materialKaKdKsn(2);
s = materialKaKdKsn(3);
n = materialKaKdKsn(4);

p = inputParser;
p.addParameter('ambient',a, @(x) validateattributes(x, {'numeric'}, {'>=', 0, '<=' 1}));
p.addParameter('diffuse',d, @(x) validateattributes(x, {'numeric'}, {'>=', 0, '<=', 1}));
p.addParameter('specular',s, @(x) validateattributes(x, {'numeric'}, {'>=', 0, '<=', 1}));
p.addParameter('specularExponent', n, @(x) validateattributes(x, {'numeric'}, {'nonnegative'}));
p.addParameter('backFaceLighting', n, @(x) validateattributes(x, {'numeric'}, {'binary'}));