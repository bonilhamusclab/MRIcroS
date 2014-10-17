function projectVolume(v, surfaceIndex, volumeFile, varargin)
%function projectVolume(v, surfaceIndex, volumeFile, varargin)
% Due to the large number of options, this function expects name-value
% pairs for varargin, for example:
%   %Use defualts for all options except interpolationMethod
%   MRIcroS('projectVolume', 1, nii_flie, 'interpolationMethod', 'spline');
% surfaceIndex: surface to be project to
% volumeFile: file name of nifti volume image to project onto surface
% averageIntensities (optional): set to 1 to average intensities
%   default 0 for performance
% interpolationMethod (optional): 'nearest', 'linear', 'spline', 'cubic', (same as function
% interp3)
%   default: linear
% colorMap (optional):
%   colorMap for projected intensities on surface
%   default: 'jet'
% threshold (optional):
%   any intensities on surface below this threshold will not be projected
%   use number greater than 1 for absolute thresholding
%   use number between 0 and 1 for percent of maximum thresholding
%       .5 => 50% of maximum surface intensity thresholded
%   default: .5
% belowThresholdColor (optional):
%   color to set surface to if below threshold
%   can be 1x3 or scalar
%   if set to scalar value (x) will be converted to [x x x];
%   default: surface color before projection
% applyGaussian (optional): set to 1 if you want to gaussian smooth voxels before
% projection
%   default: 0
%kernelSize (optional): convolution kernel size for gaussian interpolation
%   default: 13
%   not applicable if not performing gaussian smooth
%standardDev (optional): convolution kernel std for gaussian interpolation
%   default: 2.53
%   not applicable if not performing gaussian smooth

surface = v.surface(surfaceIndex);
faces = surface.faces;
vertices = surface.vertices;

p = createParserSub();
parse(p, varargin{:});

paramsStruct = p.Results;

if max(strcmp(p.UsingDefaults, 'belowThresholdColor'))
    paramsStruct.belowThresholdColor = drawing.utils.defaultLayerColorAndAlpha(surfaceIndex, v.vprefs.colors);
end

vertexColors = volumeIntensitiesToVertexColorsSub(vertices, faces, volumeFile, paramsStruct);

v.surface(surfaceIndex).vertexColors = vertexColors;

drawing.redrawSurface(v);


function p = createParserSub()
p = inputParser;
p.addParameter('averageIntensities',0);
p.addParameter('interpolationMethod','linear');
p.addParameter('colorMap', 'jet');
p.addParameter('threshold', .5, @(x) validateattributes(x, {'numeric'}, {'positive'}));
p.addParameter('belowThresholdColor', '', @(x) validateattributes(x, {'numeric'}, {'nonnegative', 'numel',3}));
p.addParameter('applyGaussian', 0, @(x) validateattributes(x, {'numeric'}, {'binary'}));
p.addParameter('kernelSize', 13, @(x) validateattributes(x, {'numeric'}, {'nonnegative'}));
p.addParameter('standardDeviation', 2.53, @(x) validateattributes(x, {'numeric'}, {'nonnegative'}));

function vertexColors = volumeIntensitiesToVertexColorsSub(vertices, faces, volumeFile, paramsStruct)
%function vertexColors = volumeIntensitiesToVertexColors(vertices, faces, volumeFile, paramsStruct)

[hdr, voxels] = fileUtils.nifti.readNifti(volumeFile);

vox_to_ras = hdr.mat;

voxels(isnan(voxels)) = 0; %is this the right way to treat NaNs?

if(paramsStruct.applyGaussian)
    voxels = smooth3(voxels,'gaussian', paramsStruct.kernelSize, paramsStruct.standardDev);
end

verticesRasSpace = [vertices ones(size(vertices,1),1)]';
verticesVoxSpace = vox_to_ras\verticesRasSpace;

%not sure why this must 2,1,3
surfaceIntensities = interp3(voxels, verticesVoxSpace(2,:), verticesVoxSpace(1,:), verticesVoxSpace(3,:), paramsStruct.interpolationMethod);
    

if paramsStruct.averageIntensities % vertex intensity smoothing: average intensity of all connected vertices: BrainNet.m EC.vol.mapalgorithm=2
    fprintf('Averaging across %d vertices - this may be very slow\n', numel(surfaceIntensities));
    clrTmp = surfaceIntensities; %original estimates for each vertex color
    for i = 1:numel(surfaceIntensities)
        [m,~] = find(faces == i);
        u = unique(faces(m,:));
        surfaceIntensities(i) = mean(clrTmp(u));
    end
end

range = max(surfaceIntensities) - min(surfaceIntensities);
if range ~= 0 %normalize for range 0 (black) to 1 (white)
    surfaceIntensitiesT = (surfaceIntensities - min(surfaceIntensities)) / range;
    %next- color balance, so typical voxels are mid-gray
    %we could use a histogram
    % http://angeljohnsy.blogspot.com/2011/04/matlab-code-histogram-equalization.html?m=1
    %instead, since range is 0..1 we will use power function to make median = 0.5
    % to determine power exponent, we compute Logarithm to an arbitrary base http://en.wikipedia.org/wiki/Logarithm 
    mdn = median(surfaceIntensitiesT(:));
    pow = log(0.5)/log(mdn);
    surfaceIntensitiesT = power(surfaceIntensitiesT, pow);
    vertexColors = utils.magnitudesToColors(surfaceIntensitiesT, paramsStruct.colorMap);
end

if ~isempty(paramsStruct.threshold)
    if paramsStruct.threshold < 1
        threshold = utils.boundArray(paramsStruct.threshold, 0, 1);
        threshold = max(surfaceIntensities(:)) * threshold;
    end
    
    if isempty(paramsStruct.belowThresholdColor)
        belowThresholdColor = utils.magnitudesToColors(0, colorMap);
    else
        belowThresholdColor = paramsStruct.belowThresholdColor;
    end
    
    if length(paramsStruct.belowThresholdColor) == 1
        belowThresholdColor = [belowThresholdColor belowThresholdColor belowThresholdColor];
    end
    
    belowThresholdColors = repmat(belowThresholdColor, sum(surfaceIntensities < threshold) ,1);
    vertexColors(surfaceIntensities < threshold,:) = belowThresholdColors;
    
end