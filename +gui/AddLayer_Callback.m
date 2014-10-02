function AddLayer_Callback(promptForValues, obj, ~)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);

supportedFileExts = '*.nii;*.hdr;*.nii.gz;*.vtk;*.nv;*.pial';
supportedFileDescs = 'NIfTI/VTK/NV/Pial';

if utils.isGiftiInstalled()
    supportedFileExts = [supportedFileExts ';*.gii'];
    supportedFileDescs = [supportedFileDescs '/GIfTI'];
end

[brain_filename, brain_pathname] = uigetfile( ...
            {supportedFileExts, supportedFileDescs; ...
            '*.*', 'All Files (*.*)'}, ...
            sprintf('Select a %s image', supportedFileDescs));

if isequal(brain_filename,0), return; end;
filename=[brain_pathname brain_filename];

reduce = .25;
thresh = Inf;
smooth = 0;

if(promptForValues)
    
	if fileUtils.isVtk(filename) || fileUtils.isGifti(filename)
        disp('no options for vtk or gifti');
	elseif fileUtils.isNv(filename) || fileUtils.isPial(filename)
        
        [reduce, cancelled] = promptNvPialDialogSub(reduce);
        if(cancelled), disp('load cancelled'); return; end;

    else
        [thresh, reduce, smooth, cancelled] = promptOptionsDialogSub(num2str(thresh),num2str(reduce),num2str(smooth));
        if(cancelled), disp('load cancelled'); return; end;
		
    end
end

commands.addLayer(v,filename, reduce, smooth, thresh);
end

function [thresh, reduce, smooth, cancelled] = promptOptionsDialogSub(defThresh, defReduce, defSmooth)
    prompt = {'Surface intensity threshold (Inf=midrange, -Inf=Otsu):','Reduce Path, e.g. 0.5 means half resolution (0..1):','Smoothing radius in voxels (0=none):'};
    dlg_title = 'Select options for loading image';
    def = {num2str(defThresh),num2str(defReduce),num2str(defSmooth)};
    answer = inputdlg(prompt,dlg_title,1,def);
    cancelled = isempty(answer);
    if cancelled
        thresh = NaN; reduce = NaN; smooth = NaN;
        return; 
    end;
    thresh = str2double(answer(1));
    reduce = str2double(answer(2));
    smooth = round(str2double(answer(3)))*2+1; %e.g. +1 for 3x3x3, +2 for 5x5x5
end
    
function [reduce, cancelled] = promptNvPialDialogSub(defReduce)
    prompt = {'Reduce Path, e.g. 0.5 means half resolution (0..1):'};
    dlg_title = 'Select options for loading Nv/Pial';
    def = {num2str(defReduce)};
    answer = inputdlg(prompt,dlg_title,1,def);
    cancelled = isempty(answer);
    if cancelled; return; end;
    reduce = str2double(answer(1));
end