% --- convert voxel image to triangle surface mesh
function voxToOpen (v,filename, thresh, reduce, smooth, isBackground)
% filename: image to open
% thresh : isosurface threshold, e.g. if 1 then voxels less than 1 are transparent
%          "Inf" or "-Inf" for automatic thresholds
% reduce : reduction factor 0..1, e.g. 0.05 will simplify mesh to 5% of original size 
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;
if (reduce > 1) || (reduce <= 0), reduce = 1; end;
Hdr = fileUtils.nifti.spm_volSub(filename); %this call clones spm_vol without dependencies
Vol = fileUtils.nifti.spm_read_volsSub(Hdr);%this call clones spm_read_vols without dependencies
%Hdr = spm_vol(filename); % <- these are the actual SPM calls
%Vol = spm_read_vols(Hdr); % <- these are the actual SPM calls
Vol(isnan(Vol)) = 0; 
if (round(smooth) > 3) %blur image prior to edge extraction
    fprintf('Applying gaussian smooth with %d voxel diameter\n',round(smooth));
    Vol = smooth3(Vol,'gaussian',round(smooth));
end;
if (isinf(thresh) && (thresh < 0)) %if -Inf, use Otsu's method
     thresh = otsuSub(Vol); %use Otsu's method to detect isosurface threshold
elseif (isnan(thresh)) || (isinf(thresh)) %if +Inf, use midpoint
	thresh = max(Vol(:)) /2; %use  max/min midpoint as isosurface threshold
    %thresh = mean(Vol(:)); %use mean to detect isosurface threshold - heavily influenced by proportion of dark air
end;
if (isBackground) 
    v = rmfield(v,'surface');
    layer = 1;
else
    layer = length( v.surface)+1;
end;
FV = isosurface(Vol,thresh);
if (reduce ~= 1.0) %next: simplify mesh
    FV = reducepatch(FV,reduce);
end;
v.surface(layer).faces = FV.faces;
v.surface(layer).vertices = FV.vertices;
v.vprefs.demoObjects = false;
clear('FV');
%next: isosurface swaps the X and Y dimensions! size(Vol)
i = 1;
j = 2;
v.surface(layer).vertices =  v.surface(layer).vertices(:,[1:i-1,j,i+1:j-1,i,j+1:end]);
%BELOW: SLOW for loop for converting from slice indices to mm
%for vx = 1:size( v.surface(layer).vertices,1) %slow - must be a way to do this with bsxfun
% wc = Hdr.mat * [ v.surface(layer).vertices(vx,:) 1]'; %convert voxel to world coordinates
% v.surface(layer).vertices(vx,:) = wc(1:3)';
%end
%BELOW: FAST vector for converting from slice indices to mm
vx = [ v.surface(layer).vertices ones(size( v.surface(layer).vertices,1),1)];
vx = mtimes(Hdr.mat,vx')';
v.surface(layer).vertices = vx(:,1:3);

%fprintf('X=%f..%f Y=%f..%f Z=%f..%f \n',min(vx(:,1)),max(vx(:,1)),min(vx(:,2)),max(vx(:,2)),min(vx(:,3)),max(vx(:,3)) );

%display results
guidata(v.hMainFigure,v);%store settings
fprintf('Surface threshold %f and reduction ratio %f yields mesh  with %d vertices and %d faces from image %s\n', thresh, reduce,size( v.surface(layer).vertices,1),size( v.surface(layer).faces,1),filename);
redrawSurface(v);
%end voxToOpen()
