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
%   vertexColor (optional)
%       * applies only to volumes (NiFTI)
%       * 0=noVertexColors, 1=defaultVertexColors, 2=vertexColorsWithOptions
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
reduce = 0.2;
reduceMesh = 1.0;
thresh = Inf;
smooth = 0;
vertexColor = 0;
if (length(varargin) >= 1) && isnumeric(varargin{1})
    reduce = varargin{1};
    reduceMesh = reduce;
end;
if (length(varargin) >= 2) && isnumeric(varargin{2}), smooth = varargin{2}; end;
if (length(varargin) >= 3) && isnumeric(varargin{3}), thresh = varargin{3}; end;
if (length(varargin) >= 4) && isnumeric(varargin{4}), vertexColor = varargin{4}; end;

[filename, isFound] = fileUtils.isFileFound(v, filename);
if ~isFound
    fprintf('Unable to find "%s"\n',filename); 
    return; 
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
v.surface(layer).colorMap = utils.colorTables(1);
v.surface(layer).colorMin = 0;
if fileUtils.isMesh(filename)
    [v.surface(layer).faces, v.surface(layer).vertices, v.surface(layer).vertexColors,...
        v.surface(layer).colorMap,v.surface(layer).colorMin] = fileUtils.readMesh(filename, reduceMesh);
else    
    %v.surface(layer).vertexColors = [];
    [v.surface(layer).faces, v.surface(layer).vertices, v.surface(layer).vertexColors] = fileUtils.readVox (filename, reduce, smooth, thresh, vertexColor);
    %if vertexColor
    %    guidata(v.hMainFigure,v);%store settings
    %    commands.projectVolume(v, layer, filename) ;
    %    v = guidata(v.hMainFigure);%retrieve latest settings
    %end
end
v.vprefs.demoObjects = false;
%display results
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end addLayerSub()