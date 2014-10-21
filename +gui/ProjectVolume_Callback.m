function ProjectVolume_Callback(obj, ~)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);
[layer, cancelled] = selectLayerSub(v);
if(cancelled), return; end;
[volumeFilename, cancelled] = selectVolumeFileSub();
if(cancelled), return; end;

answer = inputdlg({'Smooth Kernel Size (1=none, must be odd...)',...
    'Do not allow colors darker than (0..1)',...
    'Brightness (0..1, 0.5=medium)',...
    'Colormap 1=gray,2=autumn,3=bone,4=cool,5=copper,6=hot,7=hsv,8=jet,9=pink,10=winter',...
    'Average Intensities (0 no, 1 yes) - slows processing but decreases jagged edges'},...
    'Project Volume',1,...
    {'1','0','0.5', num2str(utils.colorMaps.nameIndices(v.surface(layer).colorMap)), '0'});

if isempty(answer), disp('project volume cancelled'); return; end;

smooth = str2double(answer(1));
threshold = str2double(answer(2));
brightness = str2double(answer(3));
colorMap = str2double(answer(4));

commands.projectVolume(v, layer, volumeFilename, smooth, threshold, brightness, colorMap);
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

function [volumeFilename, cancelled] = selectVolumeFileSub()
cancelled = 0;
[volumeFilename, volumePathname] = uigetfile( ...
{'*.nii; *.nii.gz; *.hdr', 'nifi files'; ...
'*.*',                   'All Files (*.*)'}, ...
'Select a Volume file');
if (~volumeFilename), disp('load volume cancelled'); cancelled = 1; return; end;
volumeFilename=[volumePathname volumeFilename];
%end selectVolumeFileSub()
