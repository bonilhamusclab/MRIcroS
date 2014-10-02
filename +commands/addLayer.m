function addLayer(v,filename,varargin)
%  filename, threshold(optional), reduce(optional), smooth(optional)
%  filename can be of type: .nii, .nii.gz, .vtk, .gii, .pial, .nv
%  All Optional values influence NIfTI volumes
%  No Optional Values have influence on meshes (VTK, GIfTI)
%  Reduce Optional value has influence on surfaces (pial, nv)
%  nb: threshold=Inf for midrange, threshold=-Inf for otsu, threshold=NaN for dialog box
%MRIcroS('addLayer','cortex_5124.surf.gii');
%MRIcroS('addLayer','attention.nii.gz',-Inf); %Otsu's threshold
%MRIcroS('addLayer','attention.nii.gz',0.05,0,3); %threshold >3
% --- add an image as a new layer on top of previously opened images
    
    [reduce, smooth, thresh] = parseInputsSub(varargin);

    if exist(filename, 'file') == 0, fprintf('Unable to find "%s"\n',filename); return; end;
    
    fileReadFn = getFileReadFnSub(filename);
    
    isBackground = v.vprefs.demoObjects;
    
    addLayerSub(v, isBackground, fileReadFn, ...
			filename, reduce, smooth, thresh);
end

function [reduce, smooth, thresh] = parseInputsSub(args)
    thresh = Inf;
	reduce = 0.25;
	smooth = 0;
	if (length(args) > 1), reduce = cell2mat(args(2)); end;
	if (length(args) > 2), smooth = cell2mat(args(3)); end;
	if (length(args) > 3), thresh = cell2mat(args(4)); end;
end

function fileReadFn = getFileReadFnSub(filename)

	if fileUtils.isVtk(filename) || ...
            (utils.isGiftiInstalled() && fileUtils.isGifti(filename))
		fileReadFn = @(filename, ~, ~, ~)fileUtils.readMesh(filename);
	elseif fileUtils.isNv(filename)
		fileReadFn = @(f, r, ~, ~) fileUtils.nv.readNv(f, r);
    elseif fileUtils.isPial(filename)
        fileReadFn = @(f, r, ~, ~) fileUtils.pial.readPial(f, r);
    else
		fileReadFn = @fileUtils.readVox;
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

    [faces, vertices] = readFileFn(filename, reduce, smooth, thresh);

    layer = utils.fieldIndex(v, 'surface');
    v.surface(layer).faces = faces;
    v.surface(layer).vertices = vertices;
    v.vprefs.demoObjects = false;

    %display results
    guidata(v.hMainFigure,v);%store settings
    drawing.redrawSurface(v);
end