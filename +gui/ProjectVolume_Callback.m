function ProjectVolume_Callback(obj, ~)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);
[layer, cancelled] = selectLayerSub(v);
if(cancelled), return; end;
[volumeFilename, cancelled] = selectVolumeFileSub();
if(cancelled), return; end;
colorMap = v.surface(layer).colorMap;
[~,colorStr] = utils.colorTables(); %text names for colorMaps
answer = inputdlg({'Smooth Kernel Size (1=none, must be odd...)',...
    'Threshold minimum (set to -Inf for no thresholding), all values below this will show surface color',...
    'Brightness (0..1, 0.5=medium)',...
    ['Colormap ' colorStr],...
    'Average Intensities (0 no, 1 yes) - slows processing but decreases jagged edges',...
    'Interpolation of volume intensities onto surface (nearest, linear, cubic, spline)'},...
    'Project Volume',1,...
    {'1','0','0.5', colorMap, '0', 'nearest'});

if isempty(answer), disp('project volume cancelled'); return; end;

smooth = str2double(answer(1));
threshold = str2double(answer(2));
brightness = str2double(answer(3));
colorMap = answer(4);
colorMap = utils.colorTables(colorMap); %verify text name
averageIntensities = str2double(answer(5));
interpMethod = answer{6};

MRIcroS('projectVolume', layer, volumeFilename, smooth, threshold, brightness, colorMap, averageIntensities, interpMethod);
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
