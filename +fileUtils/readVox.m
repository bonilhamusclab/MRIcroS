function [faces, vertices, vertexColors] = readVox (filename, reduce, smooth, thresh, vertexColor)
% filename: nii or nii.gz image to open
% thresh : isosurface threshold, e.g. if 1 then voxels less than 1 are transparent
%          "Inf" or "-Inf" for automatic thresholds
% reduce : reduction factor 0..1, e.g. 0.05 will simplify mesh to 5% of original size 
% --- convert voxel image to triangle surface mesh

vertexColors = [];
if (reduce > 1) || (reduce <= 0), reduce = 1; end;
[Hdr, Vol] = fileUtils.nifti.readNifti(filename);
Vol = double(Vol);
Vol(isnan(Vol)) = 0; 
rawVol = Vol;
smooth = round(smooth); %smooth MUST be an integer
if smooth > 0 %blur image prior to edge extraction
    if mod(smooth,2) == 0
        smooth = smooth+1;
        fprintf('Note: Smooth diameter incremented. Smooth must be an odd number (voxel diameter of kernel)\n'); 
    end;
    fprintf('Applying gaussian smooth with %d voxel diameter\n',round(smooth));
    Vol = smooth3(Vol,'gaussian',round(smooth), round(smooth) * 0.2167);
end;
if (isinf(thresh) && (thresh < 0)) %if -Inf, use Otsu's method
     thresh = utils.otsu(Vol); %use Otsu's method to detect isosurface threshold
elseif (isnan(thresh)) || (isinf(thresh)) %if +Inf, use midpoint
	thresh = max(Vol(:)) /2; %use  max/min midpoint as isosurface threshold
    %thresh = mean(Vol(:)); %use mean to detect isosurface threshold - heavily influenced by proportion of dark air
end;
Vol = clipEdgesSub(Vol,thresh);
FV = isosurface(Vol,thresh);
if isempty(FV.vertices) 
    if (min(Vol(:)) == max(Vol(:))) 
        error('All voxels in this image have the same intensity: unable to create mesh');
    end
    thresh = min(Vol(:)) + eps;
    fprintf('No vertices detected: will try again with threshold of %g',thresh);
    FV = isosurface(Vol,thresh);
end
if (reduce ~= 1.0) %next: simplify mesh
    %orig = max(FV.faces(:));
    FV = reducepatch(FV,reduce);
    %fprintf('reduced to %d -> %d vertices (%.2f)\n', orig, max(FV.faces(:)), reduce);
end;
faces = FV.faces;
vertices = FV.vertices;
clear('FV');
if vertexColor %next compute vertex colors
    vertexColors = computeVertexColors(rawVol, faces, vertices, thresh);
end
%next: isosurface swaps the X and Y dimensions! size(Vol)

i = 1;
j = 2;
vertices =  vertices(:,[1:i-1,j,i+1:j-1,i,j+1:end]);

%BELOW: SLOW for loop for converting from slice indices to mm
%for vx = 1:size( vertices,1) %slow - must be a way to do this with bsxfun
% wc = Hdr.mat * [ vertices(vx,:) 1]'; %convert voxel to world coordinates
% vertices(vx,:) = wc(1:3)';
%end
%BELOW: FAST vector for converting from slice indices to mm
vx = [ vertices ones(size(vertices,1),1)];
vx = mtimes(Hdr.mat,vx')';
vertices = vx(:,1:3);
%fprintf('X=%f..%f Y=%f..%f Z=%f..%f \n',min(vx(:,1)),max(vx(:,1)),min(vx(:,2)),max(vx(:,2)),min(vx(:,3)),max(vx(:,3)) );
%display results
fprintf('Surface threshold %f and reduction ratio %f yields mesh with %d vertices and %d faces from image %s\n', thresh, reduce,size( vertices,1),size( faces,1),filename);
%end readVox()

function Vol = clipEdgesSub(Vol,thresh)
%we will have holes on edges that exceed the threshold, we artificially set
%voxels on faces to have values less than the threshold
v = Vol;
v(2:end-1, 2:end-1, 2:end-1) = min(Vol(:));
Vol(v > thresh) = (thresh-eps-eps);
%end clipEdgesSub()

function vertexColors = computeVertexColors(Vol, faces, vertices, thresh)
smoothVol = Vol;
smoothVol(Vol(:) < thresh) = max(Vol(:));  %make air BRIGHT
smoothVol = smooth3(smoothVol,'gaussian', 13, 2.53); %smooth with 3-voxel FWHM
%else %linear interpolation
clr = interp3(smoothVol, vertices(:,1), vertices(:,2), vertices(:,3)); %isosurface order
%   clr = interp3(smoothVol, vertices(:,2), vertices(:,1), vertices(:,3)); %isosurface swap 2,1,3 and not 1,2,3
%end
fprintf('Averaging across %d vertices - this may be very slow\n', numel(clr));
clrTmp = clr; %original estimates for each vertex color
for i = 1:numel(clr) %from BrainNet Viewer http://www.nitrc.org/projects/bnv/
    [m,~] = find(faces == i);
    u = unique(faces(m,:));
    clr(i) = mean(clrTmp(u));
end
%next normalize
range = max(clr) - min(clr);
if range ~= 0 %normalize for range 0 (black) to 1 (white)
    clr = (clr - min(clr)) / range;
    %next- color balance, so typical voxels are mid-gray
    %we could use a histogram
    % http://angeljohnsy.blogspot.com/2011/04/matlab-code-histogram-equalization.html?m=1
    %instead, since range is 0..1 we will use power function to make median = 0.5
    % to determine power exponent, we compute Logarithm to an arbitrary base http://en.wikipedia.org/wiki/Logarithm 
    mdn = median(clr(:));
    pow = log(0.5)/log(mdn);
    clr = power(clr, pow);
    %vertexColors = colorSub(vertexColors, vertexColor);
end
vertexColors = clr; %note we save as scalar for precision (e.g. 'jet' has just 64 discrete values)
%end computeVertexColors()
