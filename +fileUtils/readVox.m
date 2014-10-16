function [faces, vertices] = readVox (filename, reduce, smooth, thresh)
% filename: nii or nii.gz image to open
% reduce : reduction factor 0..1, e.g. 0.05 will simplify mesh to 5% of original size 
% smooth: dimater to gaussian smooth image with, must be >= 3 and odd
% thresh : isosurface threshold, e.g. if 1 then voxels less than 1 are transparent
%          "Inf" or "-Inf" for automatic thresholds
% --- convert voxel image to triangle surface mesh

if (reduce > 1) || (reduce <= 0), reduce = 1; end;
[Hdr, Vol] = fileUtils.nifti.readNifti(filename);
Vol(isnan(Vol)) = 0; 

if (round(smooth) > 2.5) %blur image prior to edge extraction
    fprintf('Applying gaussian smooth with %d voxel diameter\n',round(smooth));
    if mod(round(smooth),2) == 0, error('Smooth diameter must be an odd number'); end;
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
if (reduce ~= 1.0) %next: simplify mesh
    FV = reducepatch(FV,reduce);
end;
faces = FV.faces;
vertices = FV.vertices;
clear('FV');

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
%end voxToOpen()

function Vol = clipEdgesSub(Vol,thresh)
%we will have holes on edges that exceed the threshold, we artificially set
%voxels on faces to have values less than the threshold
v = Vol;
v(2:end-1, 2:end-1, 2:end-1) = min(Vol(:));
Vol(v > thresh) = (thresh-eps-eps);
%end clipEdgesSub()
