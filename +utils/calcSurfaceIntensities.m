function surfaceIntensities = calcSurfaceIntensities(faces, vertices, volumeFilename, smooth, threshold, averageIntensities)
%function surfaceIntensities = calcSurfaceIntensities(faces, vertices, volumeFilename, smooth, threshold, averageIntensities)

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
    surfaceIntensities = interp3(voxels, verticesVoxSpace(2,:), verticesVoxSpace(1,:), verticesVoxSpace(3,:), 'nearest');
end
surfaceIntensities = surfaceIntensities';
%end projectVolumeSub()
