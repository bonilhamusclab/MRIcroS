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

    
    [reduce, smooth, thresh] = parseInputsSub(varargin);

    if exist(filename, 'file') == 0, fprintf('Unable to find "%s"\n',filename); return; end;
    
    fileReadFn = getFileReadFnSub(filename);
    
    isBackground = v.vprefs.demoObjects;
    
    addLayerSub(v, isBackground, fileReadFn, ...
			filename, reduce, smooth, thresh);
end

function [reduce, smooth, thresh] = parseInputsSub(args)
    defThresh = Inf;
	defReduce = 0.25;
	defSmooth = 0;
    reduce = ''; smooth = ''; thresh = '';
	if ~isempty(args), reduce = cell2mat(args(1)); end;
	if (length(args) > 1), smooth = cell2mat(args(2)); end;
	if (length(args) > 2), thresh = cell2mat(args(3)); end;
    if isempty(reduce), reduce = defReduce; end;
    if isempty(smooth), smooth = defSmooth; end;
    if isempty(thresh), thresh = defThresh; end;
end

function fileReadFn = getFileReadFnSub(filename)
    
    projectVolume = 0;

	if fileUtils.isPly(filename) || fileUtils.isTrib(filename) || fileUtils.isVtk(filename) || ...
            (utils.isGiftiInstalled() && fileUtils.isGifti(filename))
        projectVolume = 1;
		fileReadFn = @(filename, ~, ~, ~)fileUtils.readMesh(filename);
	elseif fileUtils.isNv(filename)
		fileReadFn = @(f, r, ~, ~) fileUtils.nv.readNv(f, r);
    elseif fileUtils.isPial(filename)
        fileReadFn = @(f, r, ~, ~) fileUtils.pial.readPial(f, r);
    else
		fileReadFn = @(f, r, s, t) fileUtils.readVox(f, r, s, t);
    end
    
    if ~projectVolume
        emptyVertexColors = [];
        fileReadFn = utils.appendOutput(fileReadFn, emptyVertexColors);
    end

end

function addLayerSub(v, isBackground, readFileFn, filename, reduce, smooth, thresh)
%function addSurface(v, isBackground, readFileFn, filename, reduce, smooth, thresh)
% filename: pial, nv, nii, nii.gz, vtk, gii image to open
% reduce: 
% --- open pial or nv surface image
    if isequal(filename,0), return; end;
    if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;

    if (isBackground) 
        v = drawing.removeDemoObjects(v);
    end;
    [faces, vertices, vertexColors] = readFileFn(filename, reduce, smooth, thresh);
    layer = utils.fieldIndex(v, 'surface');
    v.surface(layer).faces = faces;
    
    v.surface(layer).vertices = vertices;
    
    v.surface(layer).vertexColors = vertexColors;

    v.vprefs.demoObjects = false;

    drawing.redrawSurface(v);
end
