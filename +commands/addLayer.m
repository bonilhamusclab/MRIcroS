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
%   projectVolumeColorMap (optional)
%       * applies only to volumes (NifTI)
%       * Is the same as redering volume as a surface and than projecting
%       that volume onto the surface with projectVolume with the colorMap
%       * set to 0 to turn off and render NifTI as a regular with no
%       projections of the volume data
%       * can be any of the colorMaps specified by Matlab
%       ('jet','hsv','hot', etc...)
%       * default jet
%
%   defaults are specified if empty string ('') is input for value, or if
%   not specified
%
%  No Optional Values have influence on meshes (VTK, GIfTI)
%  thresh=Inf for midrange, thresh=-Inf for otsu
%
%MRIcroS('addLayer','cortex_5124.surf.gii'); %use defaults
%Otsu's threshold, defaults for reduce and smooth
%MRIcroS('addLayer','attention.nii.gz','thresh',-Inf);
%MRIcroS('addLayer','attention.nii.gz','reduce',0.05,'smooth', 0, 'thresh', 3); %threshold >3

p = createParserSub();
parse(p, varargin{:});

inputParams = p.Results;

inputParams.reduceMesh = 1;
if ~max(strcmp(p.UsingDefaults,'reduce'))
	inputParams.reduceMesh = inputParams.reduce;
end;

if exist(filename, 'file') == 0
    [filename, isFound] = fileUtils.getExampleFile(v.hMainFigure, filename);
    if ~isFound
        fprintf('Unable to find "%s"\n',filename); 
        return; 
    end
end;

isBackground = v.vprefs.demoObjects;
addLayerSub(v, isBackground, filename, inputParams);
%end addLayer()

function addLayerSub(v, isBackground,  filename, inputParams)
%function addSurface(v, isBackground, readFileFn, filename, reduce, smooth, thresh)
% filename: pial, nv, nii, nii.gz, vtk, gii image to open
% reduce: 
% --- open pial or nv surface image
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;

if (isBackground) 
    v = drawing.removeDemoObjects(v);
    v.vprefs.demoObjects = false;
end;

layer = utils.fieldIndex(v, 'surface');
if fileUtils.isMesh(filename)
    [v.surface(layer).faces, v.surface(layer).vertices, v.surface(layer).vertexColors] = fileUtils.readMesh(filename, inputParams.reduceMesh);
else    
    [v.surface(layer).faces, v.surface(layer).vertices] = fileUtils.readVox (filename, inputParams.reduce, inputParams.smooth, inputParams.thresh);
    vertexColors = [];
    if inputParams.projectVolumeColorMap
        commands.projectVolume(v, layer, filename, 'colorMap', inputParams.projectVolumeColorMap);
        v = guidata(v.hMainFigure);
    else
        v.surface(layer).vertexColors = vertexColors;
    end
end

%display results
v = drawing.redrawSurface(v);
guidata(v.hMainFigure,v);%store settings
%end addLayerSub()


function p = createParserSub()
p = inputParser;
p.addParameter('reduce',.25, @(x) validateattributes(x, {'numeric'}, {'<=',1,'>=',0}));
p.addParameter('smooth',1, @(x) validateattributes(x, {'numeric'}, {'isOdd','positive'}));
p.addParameter('thresh',Inf,@(x) validateattributes(x, {'numeric'}, {'real'}));
p.addParameter('projectVolumeColorMap', 'jet');
