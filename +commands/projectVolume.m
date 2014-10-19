function projectVolume(v,varargin)
% inputs: layerNumber, volumeName, smooth, threshold
% layerNumber: mesh index 
% volumeFilename: name of nifti image for background

layer = varargin{1};
volumeFilename = varargin{2};
v = guidata(v.hMainFigure);%retrieve latest settings
%provide GUI
answer = inputdlg({'Smooth (0=none,1=little,2=more...)','Do not allow colors darker than (0..1)','Brightness (0..1, 0.5=medium)','Colormap 1=gray,2=autumn,3=bone,4=cool,5=copper,6=hot,7=hsv,8=jet,9=pink,10=winter'},'Color vertices',1,{'1','0','0.5',num2str(v.surface(layer).colorMap)} );
if isempty(answer), disp('options cancelled'); return; end;
smooth = str2double(answer(1));
threshold = str2double(answer(2));
brightness = str2double(answer(3));
v.surface(layer).colorMap = str2double(answer(4));
%project new surface
v.surface(layer).vertexColors = projectVolumeSub(v.surface(layer).faces, v.surface(layer).vertices, volumeFilename, smooth, threshold);
%apply new brightness
if (brightness ~= 0.5)
    if (brightness >= 1), brightness = 1 - eps; end;
    if (brightness <= 0), brightness = eps; end;
    vc = v.surface(layer).vertexColors;
    v.surface(layer).vertexColors = (vc ./ ((((1.0 ./brightness) - 2.0) .*(1.0 - vc))+1.0));
end;
guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end projectVolumeSub()

function vertexColors = projectVolumeSub(faces, vertices, volumeFilename, smooth, threshold)
[hdr, voxels] = fileUtils.nifti.readNifti(volumeFilename);
voxels(isnan(voxels)) = min(voxels(:)); 
rawVoxels = voxels;
if (smooth > 0) %blur image prior to edge extraction
    smooth = (2* round(smooth))+1; %1->3, 2->5, etc
    if (smooth < 3), smooth = 3; end;
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
if (smooth > 0) % vertex intensity smoothing: average intensity of all connected vertices: BrainNet.m EC.vol.mapalgorithm=2
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
end
if threshold > 0  
    surfaceIntensities(surfaceIntensities < threshold,:) = threshold;
end
vertexColors = surfaceIntensities';
%end projectVolumeSub()


