function ProjectVolume_Callback(obj, ~)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);
[layer, cancelled] = selectLayerSub(v);
if(cancelled), return; end;
[volume_filename, cancelled] = selectVolumeFileSub();
if(cancelled), return; end;
commands.projectVolume(v, layer, volume_filename);
%end ProjectVolume_Callback()

function [layer, cancelled] = selectLayerSub(v)
cancelled = 0;
nlayer = length(v.surface);
if nlayer > 1
    answer = inputdlg({['Layer (1..' num2str(nlayer) ')']}, 'Enter layer to project to', 1,{'1'});
    if isempty(answer), cancelled = 1; end;
    layer = round(str2double(answer));
    layer = utils.boundArray(layer,1,nlayer);
elseif nlayer == 1
    layer = 1;
else
    error('needs a surface to project to, load surface first');
end;
%end selectLayerSub()

function [volume_filename, cancelled] = selectVolumeFileSub()
cancelled = 0;
[volume_filename, volume_pathname] = uigetfile( ...
{'*.nii; *.nii.gz; *.hdr', 'nifi files'; ...
'*.*',                   'All Files (*.*)'}, ...
'Select a Volume file');
if (~volume_filename), disp('load volume cancelled'); cancelled = 1; return; end;
volume_filename=[volume_pathname volume_filename];
%end selectVolumeFileSub()
