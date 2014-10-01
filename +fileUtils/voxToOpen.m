function voxToOpen (v,filename, thresh, reduce, smooth, isBackground)
% filename: image to open
% thresh : isosurface threshold, e.g. if 1 then voxels less than 1 are transparent
%          "Inf" or "-Inf" for automatic thresholds
% reduce : reduction factor 0..1, e.g. 0.05 will simplify mesh to 5% of original size 
% --- convert voxel image to triangle surface mesh
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;
if (reduce > 1) || (reduce <= 0), reduce = 1; end;
[Hdr, Vol] = fileUtils.nifti.readNifti(filename);
Vol(isnan(Vol)) = 0; 
if (round(smooth) > 3) %blur image prior to edge extraction
    fprintf('Applying gaussian smooth with %d voxel diameter\n',round(smooth));
    Vol = smooth3(Vol,'gaussian',round(smooth));
end;
if (isinf(thresh) && (thresh < 0)) %if -Inf, use Otsu's method
     thresh = utils.otsu(Vol); %use Otsu's method to detect isosurface threshold
elseif (isnan(thresh)) || (isinf(thresh)) %if +Inf, use midpoint
	thresh = max(Vol(:)) /2; %use  max/min midpoint as isosurface threshold
    %thresh = mean(Vol(:)); %use mean to detect isosurface threshold - heavily influenced by proportion of dark air
end;
if (isBackground) 
    v = drawing.removeDemoObjects(v);
end;
layer = utils.fieldIndex(v, 'surface');
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
drawing.redrawSurface(v);
%end voxToOpen()
