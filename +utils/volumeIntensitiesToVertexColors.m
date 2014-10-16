function vertexColors = volumeIntensitiesToVertexColors(vertices, faces, volumeFile, varargin)
%function vertexColors = projectVolume(faces, vertices, volumeFile, varargin)
% vertices: vertices to obtain colors for
% faces: faces associated with vertices
% volumeFile: file name of nifti image to project onto surface
% averageIntensities: set to 1 to average intensities
%   default 0 for performance
% interpolationMethod: 'nearest', 'linear', 'spline', 'cubic', (same as function
% interp3)
%   default: linear
% colorMap: can use any of Matlabs color map schemes
%   default: jet
% applyGaussian: set to 1 if you want to gaussian smooth voxels before
% projection
%   default: 0
%kernelSize: convolution kernel size for gaussian interpolation
%   default: 13
%standardDev:
%   default: 2.53

defaults = {0, 'linear', 'jet', 0, 13, 2.53};
[averageIntensities, interpolationMethod, colorMap, applyGaussian, kernelSize, standardDev] = ...
    utils.parseInputs(varargin, defaults);

[hdr, voxels] = fileUtils.nifti.readNifti(volumeFile);

vox_to_ras = hdr.mat;

voxels(isnan(voxels)) = 0; %is this the right way to treat NaNs?

if(applyGaussian)
    voxels = smooth3(voxels,'gaussian', kernelSize, standardDev);
end

verticesRasSpace = [vertices ones(size(vertices,1),1)]';
verticesVoxSpace = vox_to_ras\verticesRasSpace;

%not sure why this must 2,1,3
surfaceIntensities = interp3(voxels, verticesVoxSpace(2,:), verticesVoxSpace(1,:), verticesVoxSpace(3,:), interpolationMethod);
    

if averageIntensities % vertex intensity smoothing: average intensity of all connected vertices: BrainNet.m EC.vol.mapalgorithm=2
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
    surfaceIntensities = (surfaceIntensities - min(surfaceIntensities)) / range;
    %next- color balance, so typical voxels are mid-gray
        %we could use a histogram
        % http://angeljohnsy.blogspot.com/2011/04/matlab-code-histogram-equalization.html?m=1
        %instead, since range is 0..1 we will use power function to make median = 0.5
        % to determine power exponent, we compute Logarithm to an arbitrary base http://en.wikipedia.org/wiki/Logarithm 
        mdn = median(surfaceIntensities(:));
        pow = log(0.5)/log(mdn);
        surfaceIntensities = power(surfaceIntensities, pow);
        vertexColors = utils.magnitudesToColors(surfaceIntensities, colorMap);
end