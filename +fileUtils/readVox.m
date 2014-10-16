function [faces, vertices, vertexColors] = readVox (filename, reduce, smooth, thresh, vertexColor)
% filename: nii or nii.gz image to open
% thresh : isosurface threshold, e.g. if 1 then voxels less than 1 are transparent
%          "Inf" or "-Inf" for automatic thresholds
% reduce : reduction factor 0..1, e.g. 0.05 will simplify mesh to 5% of original size 
% --- convert voxel image to triangle surface mesh

vertexColors = []; %CRX - add vertexColors
if (reduce > 1) || (reduce <= 0), reduce = 1; end;
[Hdr, Vol] = fileUtils.nifti.readNifti(filename);
Vol(isnan(Vol)) = 0; 
rawVol = Vol;
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

if exist('vertexColor','var') && vertexColor > 0
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
    smoothVol = rawVol;
    mx = max(Vol(:));
    smoothVol(rawVol(:) < thresh) = mx;  %make air BRIGHT
    smoothVol = smooth3(smoothVol,'gaussian', 13, 2.53); %smooth with 3-voxel FWHM
    %Next lines save data as 32-bit floating-point NIfTI .img data
    %size(smoothVol)
    %fileID = fopen('smoothVol.img','w');
    %fwrite(fileID,smoothVol,'float32');
    %fclose(fileID);
    
    %if false %nearest neighbor - intuitive code but jagged
    %    v = round(vertices);
    %    vox = sub2ind(size(smoothVol), v(:,1), v(:,2), v(:,3));
    %    clr = smoothVol(vox);
    %else %linear interpolation
       clr = interp3(smoothVol, vertices(:,2), vertices(:,1), vertices(:,3)); %not sure why order is 2,1,3 and not 1,2,3
    %end
    if true % vertex intensity smoothing: average intensity of all connected vertices: BrainNet.m EC.vol.mapalgorithm=2
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
        %next- color balance, so typical voxels are mid-gray
        %we could use a histogram
        % http://angeljohnsy.blogspot.com/2011/04/matlab-code-histogram-equalization.html?m=1
        %instead, since range is 0..1 we will use power function to make median = 0.5
        % to determine power exponent, we compute Logarithm to an arbitrary base http://en.wikipedia.org/wiki/Logarithm 
        mdn = median(clr(:));
        pow = log(0.5)/log(mdn);
        clr = power(clr, pow);
        vertexColors = clr; %CRV [clr clr clr];
        vertexColors = colorSub(vertexColors, vertexColor);
    end
end
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

function imgrgb = colorSub(img01, clrMap)
%convert scalar Mx1 image into RGB Mx3 image using desired colormap
% img01: image in range 0..1
% clrMap: 1=grayscale(ignore),2=autumn,3=bone,4=cool,5=copper,6=hot,7=hsv,8=jet,9=pink,10=winter
if (clrMap == 1)
    imgrgb = img01;
    return; %grayscale
elseif (clrMap == 2)
    clr = autumn(64);
elseif (clrMap == 3)
    clr = bone(64);
elseif (clrMap == 4)
    clr = cool(64);
elseif (clrMap == 5)
    clr = copper(64);
elseif (clrMap == 6)
    clr = hot(64);    
elseif (clrMap == 7)
    clr = hsv(64);
elseif (clrMap == 8)
    clr = jet(64);
elseif (clrMap == 9)
    clr = pink(64);
elseif (clrMap == 10)
    clr = winter(64); 
else
    imgrgb = img01;
    return;
end
imgrgb = ind2rgb(round(img01(:) * 63)+1 ,clr);
imgrgb= reshape(imgrgb,numel(img01),3);
%end colorSub()

function Vol = clipEdgesSub(Vol,thresh)
%we will have holes on edges that exceed the threshold, we artificially set
%voxels on faces to have values less than the threshold
v = Vol;
v(2:end-1, 2:end-1, 2:end-1) = min(Vol(:));
Vol(v > thresh) = (thresh-eps-eps);
%end clipEdgesSub()
