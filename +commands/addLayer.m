function addLayer(v,filename,varargin)
% --- add an image as a new layer on top of previously opened images
%  inputs:
%   filename
%       * can be .nii, .nii.gz, .vtk, .gii, .pial, .nv
%   reduce (optional)
%       * applies to surfaces (pial/NV) and volumes (NiFTI)
%       * must be between 0 and 1
%       * default value of .25
%   smooth (optional)
%       * applies only to volumes (NiFTI)
%       * default vaMRIlue 1
%   thresh (optional)
%       * applies only to volumes (NiFTI)
%       * Inf for midrange, -Inf for Otsu
%       * defaults to Inf (midrange)
%
%   defaults are specified if empty string ('') is input for value, or if
%   not specified
%
%  No Optional Values have influence on meshes (VTK, GIfTI)
%  thresh=Inf for midrange, thresh=-Inf for otsu
%
%MRIcroS('addLayer','cortex_5124.surf.gii'); %use defaults
%Otsu's threshold, defaults for reduce and smooth
%MRIcroS('addLayer','attention.nii.gz','','',-Inf);
%MRIcroS('addLayer','attention.nii.gz',0.05,0,3); %threshold >3
reduce = 0.25;
reduceMesh = 1.0;
thresh = Inf;
smooth = 0;
vertexColor = 0;
if (nargin > 2)
    reduce = varargin{1};
    reduceMesh = reduce;
end;
if (nargin > 3), smooth = varargin{2}; end;
if (nargin > 4), thresh = varargin{3}; end;
if (nargin > 5), vertexColor = varargin{4}; end;

if exist(filename, 'file') == 0
    tmp = fullfile ([fileparts(which('MRIcroS')) filesep '+examples'], filename);
    if exist(tmp, 'file') == 0
        fprintf('Unable to find "%s"\n',filename); 
        return; 
    end
    filename = tmp; %file exists is 'examples' directory
end;
if fileUtils.isTrk(filename);
    commands.addTrack(v,filename);
    return;
end
isBackground = v.vprefs.demoObjects;
addLayerSub(v, isBackground, filename, reduce, reduceMesh, smooth, thresh, vertexColor);
%end addLayer()

function addLayerSub(v, isBackground,  filename, reduce, reduceMesh, smooth, thresh, vertexColor)
%function addSurface(v, isBackground, readFileFn, filename, reduce, smooth, thresh)
% filename: pial, nv, nii, nii.gz, vtk, gii image to open
% reduce: 
% --- open pial or nv surface image
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;

if (isBackground) 
    v = drawing.removeDemoObjects(v);
end;
layer = utils.fieldIndex(v, 'surface');
if fileUtils.isMesh(filename)
    [v.surface(layer).faces, v.surface(layer).vertices, v.surface(layer).vertexColors] = fileUtils.readMesh(filename, reduceMesh);
else    
    [v.surface(layer).faces, v.surface(layer).vertices, v.surface(layer).vertexColors] = fileUtils.readVox (filename, reduce, smooth, thresh, vertexColor);
end
v.vprefs.demoObjects = false;
%display results
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end addLayerSub()