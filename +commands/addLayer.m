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
%       * default value 1
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

%CRX projectVolume added
    
    [reduce, smooth, thresh, projectVolume] = parseInputsSub(varargin);

    if exist(filename, 'file') == 0, fprintf('Unable to find "%s"\n',filename); return; end;
    
    fileReadFn = getFileReadFnSub(filename);
    
    isBackground = v.vprefs.demoObjects;
    
    addLayerSub(v, isBackground, fileReadFn, ...
			filename, reduce, smooth, thresh, projectVolume);
end

function [reduce, smooth, thresh, projectVolume] = parseInputsSub(args)
    defThresh = Inf;
	defReduce = 0.25;
	defSmooth = 0;
    defProjectVolume = 1; %CRX
    reduce = ''; smooth = ''; thresh = ''; projectVolume = '';
	if (length(args) > 0), reduce = cell2mat(args(1)); end;
	if (length(args) > 1), smooth = cell2mat(args(2)); end;
	if (length(args) > 2), thresh = cell2mat(args(3)); end;
    if (length(args) > 3), projectVolume = cell2mat(args(4)); end;
    if isempty(reduce), reduce = defReduce; end;
    if isempty(smooth), smooth = defSmooth; end;
    if isempty(thresh), thresh = defThresh; end;
    if isempty(projectVolume), projectVolume = defProjectVolume; end;
end

function fileReadFn = getFileReadFnSub(filename)

	if fileUtils.isVtk(filename) || ...
            (utils.isGiftiInstalled() && fileUtils.isGifti(filename))
		fileReadFn = @(filename, ~, ~, ~, ~)fileUtils.readMesh(filename);
	elseif fileUtils.isNv(filename)
		fileReadFn = @(f, r, ~, ~, ~) fileUtils.nv.readNv(f, r);
    elseif fileUtils.isPial(filename)
        fileReadFn = @(f, r, ~, ~, ~) fileUtils.pial.readPial(f, r);
    else
		fileReadFn = @fileUtils.readVox;
    end

end

function addLayerSub(v, isBackground, readFileFn, filename, reduce, smooth, thresh, projectVolume)
%function addSurface(v, isBackground, readFileFn, filename, reduce, smooth, thresh)
% filename: pial, nv, nii, nii.gz, vtk, gii image to open
% reduce: 
% --- open pial or nv surface image
    if isequal(filename,0), return; end;
    if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;

    if (isBackground) 
        v = drawing.removeDemoObjects(v);
    end;
    [faces, vertices] = readFileFn(filename, reduce, smooth, thresh, projectVolume);
    layer = utils.fieldIndex(v, 'surface');
    v.surface(layer).faces = faces;
    
    v.surface(layer).vertices = vertices;

    v.vprefs.demoObjects = false;

    %display results
    guidata(v.hMainFigure,v);%store settings
    drawing.redrawSurface(v);
end
