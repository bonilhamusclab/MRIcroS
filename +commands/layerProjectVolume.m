function layerProjectVolume(v,layer, volumeFilename, smooth, threshold, brightness, averageIntensities, colormap,  interpMethod)
%function layerProjectVolume(v,layer, volumeFilename)
%a wrapper for projectVolume - but does not use value-name pairs for options
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
%   averageIntensities:
%      set to 0 to average intensities of volume voxels
%      slow but gives less jagged image
%      default 0 due to processing speed
%   colorMap:
%       name of colorMap to use for projection
%       possible values:
%           'gray','autumn','bone','cool','copper','hot','hsv','jet','pink','winter'
%   interpMethod:
%       method for interpolating the voxel intensities onto the
%       surface coordinates
%       default: nearest
%       available options are 'nearest', 'linear', 'spline', 'cubic'
%		same as options available for interp3
%Example
% MRIcroS('layerProjectVolume', 1, 'motor.nii.gz', 3, 2, 0.5, 0, 'jet', 'spline')
if nargin < 3 || isempty(volumeFilename)
    return;
end
if isempty(layer)
    layer = 1;
end
numLayers = length(v.surface);
validateattributes(layer, {'numeric'}, {'>=', 1, '<=', numLayers, 'integer'});
d.smooth = 1; d.threshold = .5; d.brightness = .5; d.colorMap = 'jet';
d.averageIntensities = 0; d.interpMethod = 'nearest';
if (nargin >= 4) && isnumeric(smooth) && (smooth >= 0), d.smooth = smooth; end
if (nargin >= 5) && isnumeric(threshold) , d.threshold = threshold; end
if (nargin >= 6) && isnumeric(brightness) , d.brightness = brightness; end
if (nargin >= 7) && isnumeric(averageIntensities) , d.averageIntensities = averageIntensities; end
if (nargin >= 8) && ischar(colormap) && ~isempty(colormap), d.colormap = colormap; end
if (nargin >= 9) && ischar(interpMethod) && ~isempty(interpMethod) , d.interpMethod = interpMethod; end
commands.projectVolume(v,layer, volumeFilename, 'smooth', d.smooth,'threshold', d.threshold,'brightness', d.brightness, 'colorMap', d.colormap,'averageIntensities', d.averageIntensities, 'interpMethod',d.interpMethod);
%end layerProjectVolume()
