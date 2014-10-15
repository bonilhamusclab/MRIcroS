function projectVolume(v, surfaceIndex, volumeFile, varargin)
% surfaceIndex: index of surface to project on
% volumeFile: file name of nifti image to project onto surface
% averageIntensities: set to 1 to average intensities
%   default 0 for performance
% interpolation: 'nearest neighbor', 'linear'
%   default: linear
%kernelSize: convolution kernel size for smoothing voxels before processing
%   default: 13
%standardDev:
%   default: 2.53


[hdr, voxels] = fileUtils.nifti.readNifti(volumeFile);

defaults = {0, 'linear', 13, 2.53};
[averageIntensities, interpolation, kernelSize, standardDev] = ...
    utils.parseInputs(varargin, defaults);

voxels(isnan(voxels)) = 0; 

surface = v.surface(surfaceIndex);
faces = surface.faces;
vertices = surface.vertices;

verticesRasSpace = [vertices ones(size(vertices,1),1)]';
verticesVoxSpace = hdr.mat\verticesRasSpace;



%http://stackoverflow.com/questions/19631279/how-to-smooth-a-3d-matrix-with-a-mask-in-matlab

%M = (Vol > 0);
%k=ones(5,5,5);
%counts = convn(M,k,'same');
%sums = convn(Vol,k,'same');
%smoothVol = sums ./counts;

%thresh2 = thresh/2;
%smoothVol(smoothVol < (thresh2)) = (thresh2);
%smoothVol(isnan(smoothVol(:))) = thresh2;
%mx = max(smoothVol(:));
%smoothVol(isnan(smoothVol(:))) = mx; %mx;
%smoothVol(smoothVol(:) == 0) = mx; %mx; %make air BRIGHT

%%mx = max(voxels(:));
%smoothVol(rawVol(:) < thresh) = mx;  %make air BRIGHT
%%smoothVol = smooth3(smoothVol,'gaussian', kernelSize, standardDev); %smooth with 3-voxel FWHM
%Next lines save data as 32-bit floating-point NIfTI .img data
%size(smoothVol)
%fileID = fopen('smoothVol.img','w');
%fwrite(fileID,smoothVol,'float32');
%fclose(fileID);

if strcmp(interpolation,'nearest neighbor')
    verticesVoxSpace = round(verticesVoxSpace);
    voxelIndexes = sub2ind(size(voxels), verticesVoxSpace(1,:), verticesVoxSpace(2,:), verticesVoxSpace(3,:));
    clr = voxels(voxelIndexes);
else %linear interpolation
   clr = interp3(smoothVol, verticesVoxSpace(1,:), verticesVoxSpace(2,:), verticesVoxSpace(3,:)); %not sure why order is 2,1,3 and not 1,2,3
end
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
    