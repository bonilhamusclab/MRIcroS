function SelectFileToOpen(v, filename, thresh, reduce,smooth)
% filename: mesh (GIFTI,VTK,PLY) or NIFTI voxel image to open
% thresh : (NIFTI only) isosurface threshold Inf for automatic, -Inf for dialog input
% reduce : (NIFTI only) path reduction ratio, e.g. 0.2 makes mesh 20% original size
% smooth : (NIFTI only) radius of smoothing, 0 = no smoothing
% --- open a mesh or voxel image
if length(filename) < 1

	supportedFileExts = '*.nii;*.hdr;*.nii.gz;*.vtk;*.nv;*.pial';
	supportedFileDescs = 'NIfTI/VTK/NV/Pial';
	if isGiftiInstalledSub()
		supportedFileExts = [supportedFileExts ';*.gii'];
		supportedFileDescs = [supportedFileDescs '/GIfTI'];
	end
	[brain_filename, brain_pathname] = uigetfile( ...
				{supportedFileExts, supportedFileDescs; ...
				'*.*', 'All Files (*.*)'}, ...
				sprintf('Select a %s image', supportedFileDescs));

    if isequal(brain_filename,0), return; end;
    filename=[brain_pathname brain_filename];
end;
if exist(filename, 'file') == 0, fprintf('Unable to find "%s"\n',filename); return; end;

isBackground = v.vprefs.demoObjects;
[pathstr, name, ext] = fileparts(filename);
if isVtkExtSub(ext) || (isGiftiInstalledSub() && isGiftiExtSub(ext))
	fileUtils.openMesh(v,filename, isBackground);
	return;
elseif isNvExtSub(ext) || isPialExtSub(ext)
    if isnan(thresh)
        [reduce, cancelled] = promptNvPialDialogSub(reduce);
        if(cancelled), disp('load cancelled'); return; end;
    end
    
    fileReadFn = @fileUtils.nv.readNv;
    if isPialExtSub(ext)
        fileReadFn = @fileUtils.pial.readPial;
    end
    
    fileUtils.surfaceToOpen(fileReadFn, v, filename, reduce, isBackground);
	return
end;

if isnan(thresh)
    thresh = Inf;%infinity means auto-select
    [thresh, reduce, smooth, cancelled] = promptOptionsDialogSub(num2str(thresh),num2str(reduce),num2str(smooth));
    if(cancelled), disp('load cancelled'); return; end;
end

%detect and unpack .nii.gz to .nii
isTmpUnpackedGz = false;
if isGzExtSub(ext) 
    ungzname = fullfile(pathstr, name);
    if exist(ungzname, 'file') ~= 0
        fprintf('Warning: File exists named %s; will open in place of %s\n',ungzname, filename);
        filename = ungzname;
    else
        filename = char(gunzip(filename));
        isTmpUnpackedGz = true;
    end;
end;
fileUtils.voxToOpen(v,filename, thresh, reduce,smooth, isBackground); %load voxel image
if (isTmpUnpackedGz), delete(filename); end; %remove temporary uncompressed image



%end SelectFileToOpen() 



function [thresh, reduce, smooth, cancelled] = promptOptionsDialogSub(defThresh, defReduce, defSmooth)
    prompt = {'Surface intensity threshold (Inf=midrange, -Inf=Otsu):','Reduce Path, e.g. 0.5 means half resolution (0..1):','Smoothing radius in voxels (0=none):'};
    dlg_title = 'Select options for loading image';
    def = {num2str(defThresh),num2str(defReduce),num2str(defSmooth)};
    answer = inputdlg(prompt,dlg_title,1,def);
    cancelled = isempty(answer);
    if cancelled; return; end;
    thresh = str2double(answer(1));
    reduce = str2double(answer(2));
    smooth = round(str2double(answer(3)))*2+1; %e.g. +1 for 3x3x3, +2 for 5x5x5
    
function [reduce, cancelled] = promptNvPialDialogSub(defReduce)
    prompt = {'Reduce Path, e.g. 0.5 means half resolution (0..1):'};
    dlg_title = 'Select options for loading Nv/Pial';
    def = {num2str(defReduce)};
    answer = inputdlg(prompt,dlg_title,1,def);
    cancelled = isempty(answer);
    if cancelled; return; end;
    reduce = str2double(answer(1));

function installed = isGiftiInstalledSub()
	installed = (exist('gifti.m', 'file') == 2);

function isVtk = isVtkExtSub(fileExt)
	isVtk = strcmpi(fileExt, '.vtk');

function isGifti = isGiftiExtSub(fileExt)
	isGifti = strcmpi(fileExt, '.gii');

function isGz = isGzExtSub(fileExt)
	isGz = length(fileExt)==3  && min((fileExt=='.gz')==1);

function isNv = isNvExtSub(fileExt)
	isNv = strcmpi(fileExt, '.nv');

function isPial = isPialExtSub(fileExt)
	isPial = strcmpi(fileExt, '.pial');
