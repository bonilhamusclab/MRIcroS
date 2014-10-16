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
%       * defaults to Inf (midrange
%   vertexColor (optional)
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

defaults = {.25, Inf, 0, 0};
[reduce, thresh, smooth, vertexColor] = ...
    utils.parseInputs(varargin, defaults);

reduceMesh = 1;
if (nargin > 2)
	reduceMesh = reduce;
end;

if exist(filename, 'file') == 0
    [filename, isFound] = fileUtils.getExampleFile(v.hMainFigure, filename);
    if ~isFound
        fprintf('Unable to find "%s"\n',filename); 
        return; 
    end
end;

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