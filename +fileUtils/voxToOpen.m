% --- convert voxel image to triangle surface mesh
function voxToOpen (v,filename, thresh, reduce, smooth, isBackground)
% filename: image to open
% thresh : isosurface threshold, e.g. if 1 then voxels less than 1 are transparent
%          "Inf" or "-Inf" for automatic thresholds
% reduce : reduction factor 0..1, e.g. 0.05 will simplify mesh to 5% of original size 
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;
if (reduce > 1) || (reduce <= 0), reduce = 1; end;
Hdr = spm_volSub(filename); %this call clones spm_vol without dependencies
Vol = spm_read_volsSub(Hdr);%this call clones spm_read_vols without dependencies
%Hdr = spm_vol(filename); % <- these are the actual SPM calls
%Vol = spm_read_vols(Hdr); % <- these are the actual SPM calls
Vol(isnan(Vol)) = 0; 
if (round(smooth) > 3) %blur image prior to edge extraction
    fprintf('Applying gaussian smooth with %d voxel diameter\n',round(smooth));
    Vol = smooth3(Vol,'gaussian',round(smooth));
end;
if (isinf(thresh) && (thresh < 0)) %if -Inf, use Otsu's method
     thresh = otsu(Vol); %use Otsu's method to detect isosurface threshold
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


% --- load NIfTI voxel data: mimics spm_read_vol without requiring SPM
function [img] = spm_read_volsSub(hdr)
if (exist(hdr.fname, 'file') ~= 2)
    fprintf('Error: unable to find %s', hdr.fname);
    return;
end;
switch hdr.dt(1)
   case   2,
      bitpix = 8;  myprecision = 'uint8';
   case   4,
      bitpix = 16; myprecision = 'int16';
   case   8,
      bitpix = 32; myprecision = 'int32';
   case  16,
      bitpix = 32; myprecision = 'float32';
   case  64,
      bitpix = 64; myprecision = 'float64';
   case 512 
      bitpix = 16; myprecision = 'uint16';
   case 768 
      bitpix = 32; myprecision = 'uint32';
   otherwise
      error('This datatype is not supported'); 
end
myvox = hdr.dim(1)*hdr.dim(2)*hdr.dim(3);
%ensure file is large enough
file_stats = dir(hdr.fname);
imgbytes = (myvox * (bitpix/8))+hdr.pinfo(3); %image bytes plus offset
if (imgbytes > file_stats.bytes)
    fprintf('Error: expected %d but file has %d bytes %s',imgbytes, file_stats.bytes,hdr.fname);
    return;
end;
%read data
fid = fopen(hdr.fname,'r');
if  (hdr.dt(2) == 0)
    myformat = 'l'; %little-endian
else
    myformat = 'b'; %big-endian
end;    
fseek(fid, hdr.pinfo(3), 'bof');
img = fread(fid, myvox, myprecision, 0, myformat);
img = img(:).*hdr.pinfo(1)+hdr.pinfo(2); %apply scale slope and intercept
img = reshape(img,hdr.dim(1),hdr.dim(2),hdr.dim(3));
fclose(fid);
%end spm_read_volsSub()


% --- load NIfTI header: mimics spm_vol without requiring SPM
function [Hdr] = spm_volSub(filename)
[h, ~, fileprefix, machine] = fileUtils.nifti.load_nii_hdr(filename);
Hdr.dim = [h.dime.dim(2) h.dime.dim(3) h.dime.dim(4)];
if (h.hist.sform_code == 0) && (h.hist.qform_code == 0)
    fprintf('Warning: no spatial transform detected. Perhaps Analyze rather than NIfTI format');
    Hdr.mat = fileUtils.nifti.hdr2m(h.dime.dim,h.dime.pixdim );
elseif (h.hist.sform_code == 0) && (h.hist.qform_code > 0) %use qform Quaternion only if no sform
    Hdr.mat = fileUtils.nifti.quarternion.hdrQ2m(h.hist,h.dime.dim,h.dime.pixdim );
else %precedence: get spatial transform from matrix (sform)
    Hdr.mat = [h.hist.srow_x; h.hist.srow_y; h.hist.srow_z; 0 0 0 1];
    Hdr.mat = Hdr.mat*[eye(4,3) [-1 -1 -1 1]']; % mimics SPM: Matlab arrays indexed from 1 not 0 so translate one voxel
end;
if (machine == 'ieee-le')
	Hdr.dt = [h.dime.datatype 0];
else
	Hdr.dt = [h.dime.datatype 1];
end;
Hdr.pinfo = [h.dime.scl_slope; h.dime.scl_inter; h.dime.vox_offset];
if findstr('.hdr',filename) & strcmp(filename(end-3:end), '.hdr')
	Hdr.fname =  [fileprefix '.img']; %if file.hdr then set to file.img
else
	Hdr.fname =  filename;
end
Hdr.descrip = h.hist.descrip;
Hdr.n = [h.dime.dim(5) 1];
Hdr.private.hk = h.hk;
Hdr.private.dime = h.dime;
Hdr.private.hist = h.hist;
%end spm_volSub()
