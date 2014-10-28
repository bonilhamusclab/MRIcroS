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
%       * convolution kernel size for gaussian smoothing
%       * default value 1 (no smoothing)
%       * must be odd number
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

inputs = parseInputParamsSub(varargin);
reduce = inputs.reduce; 
reduceMesh = inputs.reduceMesh;
smooth = inputs.smooth;
thresh = inputs.thresh; 
vertexColor = inputs.vertexColor;

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


function inputParams = parseInputParamsSub(args)
p = inputParser;
d.reduce = .2; d.smooth = 1; d.thresh = Inf; d.vertexColor = 0;

p.addOptional('reduce', d.reduce, ...
    @(x) validateattributes(x, {'numeric'}, {'<=',1,'>=',0}));
p.addOptional('smooth', d.smooth, ...
    @(x) validateattributes(x, {'numeric'}, {'integer', '>=',0})); %smooth 0=none, 1=little, 2=more...
p.addOptional('thresh', d.thresh, ...
    @(x) validateattributes(x, {'numeric'}, {'real'}));
p.addOptional('vertexColor', d.vertexColor, ...
    @(x) validateattributes(x, {'numeric'}, {'<=', 14, '>=', 0}));
p = utils.stringSafeParse(p, args, fieldnames(d), d.reduce, d.smooth, d.thresh, ...
    d.vertexColor);
inputParams = p.Results;
inputParams.reduceMesh = 1.0;
if ~max(strcmp(p.UsingDefaults,'reduce'))
	inputParams.reduceMesh = inputParams.reduce;
end;