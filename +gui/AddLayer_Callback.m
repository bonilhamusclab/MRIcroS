function AddLayer_Callback(promptForValues, obj, ~)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);
supportedFileExts = '*.nii;*.hdr;*.nii.gz;*.vtk;*.nv;*.pial;*.ply;*.trk;*.stl;*.mat';
supportedFileDescs = 'NIfTI/VTK/NV/Pial/PLY/trk/mat';

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
if fileUtils.isTrk(filename)
    if ~promptForValues
		MRIcroS('addTrack',filename);
    else
        %from AddTracks_Callback
        prompt = {'Track Sampling (1/ts tracks will be loaded, large values increase speed but decreases information):','Minimum fiber length (only sampled tracks with this minimum fiber length will be rendered, increases speed but decreases information):'};
        opts = inputdlg(prompt, 'Track Options', 1, {num2str(100), num2str(5)});
        if isempty(opts), disp('load cancelled'); return; end;
        trackSpacing = str2double(opts(1));
        fiberLen = str2double(opts(2));
		MRIcroS('addTrack', filename, trackSpacing, fiberLen);
    end
    return;
end
reduce = 1;
thresh = '';
smooth = '';
vertexColor = '';%assume user does not want vertex colors
if(promptForValues)  
    if fileUtils.isMesh(filename)
        if fileUtils.isNv(filename) || fileUtils.isPial(filename)
            [reduce, cancelled] = promptNvPialDialogSub(reduce);
            if(cancelled)
                disp('load cancelled'); 
                return;
            end
        else
           disp('no options for meshes'); 
        end
    else
        reduce = '0.05'; %supply reasonable default values
        thresh = 'Inf';
        smooth = '0';
        vertexColor = '0'; 
        [thresh, reduce, smooth, vertexColor, cancelled] = promptOptionsDialogSub(filename,num2str(thresh),num2str(reduce),num2str(smooth),num2str(vertexColor));
        if(cancelled), disp('load cancelled'); return; end;
    end
end
MRIcroS('addLayer',filename, reduce, smooth, thresh, vertexColor);
if promptForValues && ~fileUtils.isMesh(filename) && vertexColor
    v = guidata(v.hMainFigure);
    MRIcroS('vertexColorBrightness',length(v.surface)); %change brightness of most recent layer
end
%end AddLayer_Callback()

function [thresh, reduce, smooth, vertexColor, cancelled] = promptOptionsDialogSub(filename, defThresh, defReduce, defSmooth, defVertexColor)

gui.volumeRender.quickDataViewPopup(filename);

prompt = {'Surface intensity threshold (Inf=midrange, -Inf=Otsu):','Reduce Path, e.g. 0.5 means half resolution (0..1):','Smoothing radius in voxels (0=none):',...
    'Vertex color (0=no,1=yes):'};
dlg_title = 'Select options for loading image';
def = {num2str(defThresh),num2str(defReduce),num2str(defSmooth),num2str(defVertexColor)};
answer = inputdlg(prompt,dlg_title,1,def);
cancelled = isempty(answer);
if cancelled
    thresh = NaN; reduce = NaN; smooth = NaN; vertexColor = NaN;
    return; 
end;
thresh = str2double(answer(1));
reduce = str2double(answer(2));
smooth = round(str2double(answer(3)))*2+1; %e.g. +1 for 3x3x3, +2 for 5x5x5
vertexColor = str2double(answer(4));
%end promptOptionsDialogSub()
    
function [reduce, cancelled] = promptNvPialDialogSub(defReduce)
prompt = {'Reduce Path, e.g. 0.5 means half resolution (0..1):'};
dlg_title = 'Select options for loading Nv/Pial';
def = {num2str(defReduce)};
answer = inputdlg(prompt,dlg_title,1,def);
cancelled = isempty(answer);
if cancelled; return; end;
reduce = str2double(answer(1));
%end promptNvPialDialogSub
