function projectVolume(v,layer, volumeFilename, varargin)
%function projectVolume(v,layer, volumeFilename)
% inputs:
%   layer: mesh index 
%   volumeFilename: name of nifti image for background
% Optional Inputs:
%   smooth:
%       convolution size of kernel for Gaussian smooth before projection
%       defaults to 1 for no Gaussian smoothing
%   threshold:
%       threshold below volume intensities are not projected
%       defaults to .5
%   brightness:
%   `   how bright projection should be
%       defaults to .5 - no increase or decrease
%   colorMap:
%       index of colorMap to use for projection
%       defaults to color map for layer
%       possible values:
%           1=gray,2=autumn,3=bone,4=cool,5=copper,6=hot,7=hsv,8=jet,9=pink,10=winter'
%   averageIntensities:
%      set to 0 to average intensities of volume voxels
%      slow but gives less jagged image
%      default 0 due to processing speed
%   interpMethod:
%       method for interpolating the voxel intensities onto the
%       surface coordinates
%       default: nearest
%       available options are 'nearest', 'linear', 'spline', 'cubic'
%		same as options available for interp3

v = guidata(v.hMainFigure);%retrieve latest settings
%provide GUI

colorMap = utils.colorMaps.nameIndices(v.surface(layer).colorMap);

[volumeFilename, isFound] = fileUtils.isFileFound(v, volumeFilename);
if ~isFound
    fprintf('Unable to find "%s"\n',volumeFilename); 
    return; 
end;

inputs = parseInputParams(colorMap, varargin);
smooth = inputs.smooth;
threshold = inputs.threshold;
brightness = inputs.brightness;
averageIntensities = inputs.averageIntensities;
interpMethod = inputs.interpMethod;
colorMap = inputs.colorMap;

surfaceColor = drawing.utils.currentLayerRGBA(layer, v.vprefs.colors);

v.surface(layer).colorMap = colorMap;

%project new surface
v.surface(layer).vertexColors = projectVolumeSub(v.surface(layer).faces, v.surface(layer).vertices, volumeFilename, smooth, threshold, averageIntensities, interpMethod, surfaceColor, colorMap);

%apply new brightness
if (brightness ~= 0.5)
    if (brightness >= 1), brightness = 1 - eps; end;
    if (brightness <= 0), brightness = eps; end;
    vc = v.surface(layer).vertexColors;
    v.surface(layer).vertexColors = (vc ./ ((((1.0 ./brightness) - 2.0) .*(1.0 - vc))+1.0));
end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end projectVolume()

function vertexColors = projectVolumeSub(faces, vertices, volumeFilename, smooth, threshold, averageIntensities, interpMethod, surfaceColor, colorMap)

[hdr, voxels] = fileUtils.nifti.readNifti(volumeFilename);
voxels(isnan(voxels)) = min(voxels(:)); 

if (smooth > 1) %blur image prior to edge extraction
    fprintf('Applying gaussian smooth with %d voxel diameter\n',round(smooth));
    if mod(round(smooth),2) == 0, error('Smooth diameter must be an odd number'); end;
    voxels = smooth3(voxels,'gaussian',round(smooth), round(smooth) * 0.2167);
end;

%thresh = 30;
%mx = max(voxels(:));
%voxels(rawVoxels(:) < thresh) = mx;  %make air BRIGHT   
vox_to_ras = hdr.mat;
verticesRasSpace = [vertices ones(size(vertices,1),1)]';
verticesVoxSpace = vox_to_ras\verticesRasSpace;
%not sure why interp3 order is 2,1,3 instead of 1,2,3 
if averageIntensities % vertex intensity smoothing: average intensity of all connected vertices: BrainNet.m EC.vol.mapalgorithm=2
    surfaceIntensities = interp3(voxels, verticesVoxSpace(2,:), verticesVoxSpace(1,:), verticesVoxSpace(3,:), 'spline');
    fprintf('Averaging across %d vertices - this may be very slow\n', numel(surfaceIntensities));
    clrTmp = surfaceIntensities; %original estimates for each vertex color
    for i = 1:numel(surfaceIntensities)
        [m,~] = find(faces == i);
        u = unique(faces(m,:));
        surfaceIntensities(i) = mean(clrTmp(u));
    end
else
    surfaceIntensities = interp3(voxels, verticesVoxSpace(2,:), verticesVoxSpace(1,:), verticesVoxSpace(3,:), interpMethod);
end

projectedIndices = surfaceIntensities >= threshold;
surfaceIntensitiesToProject = surfaceIntensities(projectedIndices);

range = max(surfaceIntensitiesToProject) - min(surfaceIntensitiesToProject);
if range ~= 0 %normalize for range 0 (black) to 1 (white)
    normalizedSurfaceIntensities = (surfaceIntensitiesToProject - min(surfaceIntensitiesToProject)) / range;
    %next- color balance, so typical voxels are mid-gray
    %we could use a histogram
    % http://angeljohnsy.blogspot.com/2011/04/matlab-code-histogram-equalization.html?m=1
    %instead, since range is 0..1 we will use power function to make median = 0.5
    % to determine power exponent, we compute Logarithm to an arbitrary base http://en.wikipedia.org/wiki/Logarithm 
    mdn = median(normalizedSurfaceIntensities(:));
    pow = log(0.5)/log(mdn);
    normalizedSurfaceIntensities = power(normalizedSurfaceIntensities, pow);
end
vertexColors(projectedIndices, :) =  utils.magnitudesToColors(normalizedSurfaceIntensities', colorMap);

vertexColors(~projectedIndices,:) = repmat(surfaceColor,[sum(~projectedIndices) 1]);

%end projectVolumeSub()

function inputParams = parseInputParams(colorMap, args)
p = inputParser;

d.smooth = 1; d.threshold = .5; d.brightness = .5; d.colorMap = colorMap;
d.averageIntensities = 0; d.interpMethod = 'nearest';

p.addOptional('smooth',d.smooth, ...
    @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'odd'}));
p.addOptional('threshold', d.threshold, @(x) validateattributes(x, {'numeric'}, {'real'}));
p.addOptional('brightness', d.brightness, @(x) validateattributes(x, {'numeric'}, {'>=', 0, '<=', 1}));
p.addOptional('colorMap', d.colorMap, ...
    @(x) validateattributes(x, {'numeric'}, {'positive', 'integer', '<=', 13}));
p.addOptional('averageIntensities', d.averageIntensities, ...
    @(x) validateattributes(x, {'numeric'}, {'binary'}));
p.addOptional('interpMethod', d.interpMethod',...
    @(x) validateattributes(x, {'char'}, {'nonempty'}));

p = utils.stringSafeParse(p, args, fieldnames(d), d.smooth, d.threshold, d.brightness, d.colorMap, d.averageIntensities, d.interpMethod);

inputParams = p.Results;
