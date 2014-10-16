function ProjectVolume_Callback(promptForValues, obj, ~)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);

[layer, cancelled] = selectLayerSub(v);
if(cancelled), return; end;

[volume_filename, cancelled] = selectVolumeFileSub();
if(cancelled), return; end;

if(~promptForValues)
    commands.projectVolume(v, layer, volume_filename);
else
    [averageIntensities, interpMethod, colorMap, applyGauss, kernelSize, stdDev] = ...
        getOptionsSub();
    commands.projectVolume(v, layer, volume_filename, ...
        averageIntensities, interpMethod, colorMap, applyGauss, ...
        kernelSize, stdDev);
end

end

function [layer, cancelled] = selectLayerSub(v)
    cancelled = 0;
    nlayer = length(v.surface);
    if nlayer > 1
        answer = inputdlg({['Layer (1..' num2str(nlayer) ')']}, 'Enter layer to project to', 1,{'1'});
        if isempty(answer), disp('options cancelled'); return; end;
        layer = round(str2double(answer));
        layer = utils.boundArray(layer,1,nlayer);
    elseif nlayer == 1
        layer = 1;
    else
        error('needs a surface to project to, load surface first');
    end;
end

function [volume_filename, cancelled] = selectVolumeFileSub()
    cancelled = 0;
    [volume_filename, volume_pathname] = uigetfile( ...
    {'*.nii; *.nii.gz', 'nifi files'; ...
    '*.*',                   'All Files (*.*)'}, ...
    'Select a Volume file');
    if (~volume_filename), disp('load volume cancelled'); cancelled = 1; return; end;
    volume_filename=[volume_pathname volume_filename];
end

function [averageIntensities, interpMethod, colorMap, applyGauss, kernelSize, stdDev] = getOptionsSub()
    averageIntensities = ''; interpMethod =''; applyGauss = ''; kernelSize = ''; stdDev = '';

    defaults = {'0', '1', '0', '13', '2.53'};
    prompt = {'Average Color Intensities? (1 Yes, 0 No):',...
        'interpolation method for projecting volume onto surface (1 nearest, 2 linear, 3 spline, 4 cubic):',...
        'Apply Guassian Filter before interpolation? (1 Yes, 0 No):',...
        'Gaussian Filter Kernel Size (only applies if using Guassian Filter):',...
        'Gaussian Filter Standard Deviation Size (only applies if using Guassian Filter):'...
        };
    opts = inputdlg(prompt, 'Projection Options', 1, defaults);
    if isempty(opts), disp('options cancelled, using defualts'); return; end;
    averageIntensities = str2double(opts(1));
    interpMethod = interpNumberToMethodSub(str2double(opts(2)));
    applyGauss = str2double(opts(3));
    kernelSize = str2double(opts(4));
    stdDev = str2double(opts(5));
    
    [colorMap, isCancelled] = gui.utils.promptColorMap();
    if(isCancelled)
        colorMap = 'jet'; 
        disp(['color map selection cancelled, using ' colorMap]);
    end
    
end

function method = interpNumberToMethodSub(number)
    switch(number)
        case (1)
            method = 'linear';
        case (2)
            method = 'nearest';
        case (3)
            method = 'spline';
        case (4)
            method = 'cubic';
        otherwise
            method = 'linear';
    end
end
