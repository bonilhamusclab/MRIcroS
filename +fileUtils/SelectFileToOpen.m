% --- open a mesh or voxel image
function SelectFileToOpen(v, filename, thresh, reduce,smooth)
% filename: mesh (GIFTI,VTK,PLY) or NIFTI voxel image to open
% thresh : (NIFTI only) isosurface threshold Inf for automatic, -Inf for dialog input
% reduce : (NIFTI only) path reduction ratio, e.g. 0.2 makes mesh 20% original size
% smooth : (NIFTI only) radius of smoothing, 0 = no smoothing
if length(filename) < 1
    if (exist('gifti.m', 'file') == 2)
        [brain_filename, brain_pathname] = uigetfile( ...
                    {'*.nii;*.hdr;*.nii.gz;*.gii;*.vtk', 'NIfTI/GIfTI/VTK files'; ...
                    '*.*',                   'All Files (*.*)'}, ...
                    'Select a NIfTI image');
    else
        [brain_filename, brain_pathname] = uigetfile( ...
                    {'*.nii;*.hdr;*.nii.gz', 'NIfTI/VTK files'; ...
                    '*.*',                   'All Files (*.*)'}, ...
                    'Select a NIfTI image');
    end;
    if isequal(brain_filename,0), return; end;
    filename=[brain_pathname brain_filename];
end;
isBackground = v.vprefs.demoObjects;
if exist(filename, 'file') == 0, fprintf('Unable to find "%s"\n',filename); return; end;
[pathstr, name, ext] = fileparts(filename);
if (length(ext) == 4) && strcmpi(ext,'.vtk')
        fileUtils.openMesh(v,filename, isBackground);
        return;
end; %VTK file
if (exist('gifti.m', 'file') == 2) &&  (length(ext) == 4) && strcmpi(ext,'.gii')
        openMesh(v,filename, isBackground);
        return;
end; %GIFTI file
if isnan(thresh)
    thresh = Inf;%infinity means auto-select
    prompt = {'Surface intensity threshold (Inf=midrange, -Inf=Otsu):','Reduce Path, e.g. 0.5 means half resolution (0..1):','Smoothing radius in voxels (0=none):'};
    dlg_title = 'Select options for loading image';
    def = {num2str(thresh),num2str(reduce),num2str(smooth)};
    answer = inputdlg(prompt,dlg_title,1,def);
    if isempty(answer), disp('load cancelled'); return; end;
    %if length(answer) == 0, disp('load cancelled'); return; end;
    thresh = str2double(answer(1));
    reduce = str2double(answer(2));
    smooth = round(str2double(answer(3)))*2+1; %e.g. +1 for 3x3x3, +2 for 5x5x5
end; 
%next - detect and unpack .nii.gz to .nii
isGZ = false;
if (length(ext)==3)  && min((ext=='.gz')==1) 
    ungzname = fullfile(pathstr, name);
    if exist(ungzname, 'file') ~= 0
        fprintf('Warning: File exists named %s; will open in place of %s\n',ungzname, filename);
        filename = ungzname;
    else
        filename = char(gunzip(filename));
        isGZ = true;
    end;
end;
fileUtils.voxToOpen(v,filename, thresh, reduce,smooth, isBackground); %load voxel image
if (isGZ), delete(filename); end; %remove temporary uncompressed image
%end SelectFileToOpen() 
