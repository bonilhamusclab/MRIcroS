function projectVolume(v, surfaceIndex, volumeFile, varargin)
% surfaceIndex: index of surface to project on
% volumeFile: file name of nifti image to project onto surface
% averageIntensities: set to 1 to average intensities
%   default 0 for performance
% interpolationMethod: 'nearest', 'linear', 'spline', 'cubic', (same as function
% interp3
%   default: linear
% applyGaussian: set to 1 if you want to gaussian smooth voxels before
% projection
%   default: 0
%kernelSize: convolution kernel size for gaussian interpolation
%   default: 13
%standardDev:
%   default: 2.53

defaults = {0, 'linear', 0, 13, 2.53};
[averageIntensities, interpolationMethod, applyGaussian, kernelSize, standardDev] = ...
    utils.parseInputs(varargin, defaults);

[hdr, voxels] = fileUtils.nifti.readNifti(volumeFile);

voxels(isnan(voxels)) = 0; %is this the right way to treat NaNs?

if(applyGaussian)
    voxels = smooth3(voxels,'gaussian', kernelSize, standardDev);
end

surface = v.surface(surfaceIndex);
faces = surface.faces;
vertices = surface.vertices;

verticesRasSpace = [vertices ones(size(vertices,1),1)]';
verticesVoxSpace = hdr.mat\verticesRasSpace;

%not sure why this must 2,1,3
clr = interp3(voxels, verticesVoxSpace(2,:), verticesVoxSpace(1,:), verticesVoxSpace(3,:), interpolationMethod);
    

if averageIntensities % vertex intensity smoothing: average intensity of all connected vertices: BrainNet.m EC.vol.mapalgorithm=2
    fprintf('Averaging across %d vertices - this may be very slow\n', numel(clr));
    clrTmp = clr; %original estimates for each vertex color
    for i = 1:numel(clr)
        [m,~] = find(faces == i);
        u = unique(faces(m,:));
        clr(i) = mean(clrTmp(u));
    end
end

range = max(clr) - min(clr);
if range ~= 0 %normalize for range 0 (black) to 1 (white)
    clr = (clr - min(clr)) / range;
end

v.surface(surfaceIndex).vertexColors = clr';

drawing.redrawSurface(v);
