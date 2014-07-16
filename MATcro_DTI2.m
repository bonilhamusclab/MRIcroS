function varargout = MATcro_DTI(varargin)
% surface rendering for NIfTI images, can be run from user interface or scripted
%Examples:
% MATcro %launch MATcro
% MATcro('openLayer',{'avg152T1_brain.nii.gz'}); %open image
% MATcro('simplifyLayers', 0.5); %reduce mesh to 50% complexity
% MATcro('closeLayers'); %close all images
% MATcro('openLayer',{'cortex_20484.surf.gii'}); %open image
% MATcro('openLayer',{'attention.nii.gz'}, 3.0); %add fMRI overlay, threshold t>3
% MATcro('openLayer',{'saccades.nii.gz'}, 3.0); %add fMRI overlay threshold t>3
% MATcro('openLayer',{'scalp_2562.surf.gii'}); %add scalp overlay
% MATcro('layerRGBA', 4, 0.9, 0.5, 0.5, 0.2); %make scalp reddish
% MATcro('setMaterial', 0.1, 0.4, 0.9, 50, 0, 1); %make surfaces shiny
% for i=-27:9
% 	MATcro('setView', i*10, 35); %rotate azimuth, constant elevation
% 	pause(0.1);
% end;
% MATcro('copyBitmap'); %copy screenshot to clipboard
% MATcro('saveBitmap',{'myPicture.png'}); %save screenshot
% MATcro('saveMesh',{'myMesh.ply'}); %export mesh to PLY format
mOutputArgs = {}; % Variable for storing output when GUI returns
h = findall(0,'tag',mfilename); %run as singleton
if (isempty(h)) % new instance
   h = makeGui(); %set up user interface
else % instance already running
   figure(h);  %Figure exists so bring Figure to the focus
end;
if (nargin) && (ischar(varargin{1})) 
 f = str2func(varargin{1});
 f(guidata(h),varargin{2:nargin})
end
mOutputArgs{1} = h;% return handle to main figure
if nargout>0
 [varargout{1:nargout}] = mOutputArgs{:};
end
%end MATcro() --- SUBFUNCTIONS FOLLOW

% --- add an image as a new layer on top of previously opened images
function openLayer(v,varargin)
%  filename, threshold(optional), reduce(optional), smooth(optional)
% Optional values only influence NIfTI volumes, not meshes (VTK, GIfTI)
%  nb: threshold=Inf for midrange, threshold=-Inf for otsu, threshold=NaN for dialog box
%MATcro('openLayer',{'cortex_5124.surf.gii'});
%MATcro('openLayer',{'attention.nii.gz'}); %midrange threshold
%MATcro('openLayer',{'attention.nii.gz',-Inf}); %Otsu's threshold
%MATcro('openLayer',{'attention.nii.gz'},3,0.05,0); %threshold >3
if (length(varargin) < 1), return; end;
thresh = Inf;
reduce = 0.25;
smooth = 0;
filename = char(varargin{1});
if (length(varargin) > 1), thresh = cell2mat(varargin(2)); end;
if (length(varargin) > 2), reduce = cell2mat(varargin(3)); end;
if (length(varargin) > 3), smooth = cell2mat(varargin(4)); end;
SelectFileToOpen(v,filename, thresh, reduce, smooth);
%end openLayer()

% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat
function addTrack(v,varargin)
%  filename
%MATcro('addTrack','dti.trk');
if (length(varargin) < 1), return; end;
filename = char(varargin{1});
tic

    hold on
    [header,tracks] = trk_read2(filename,true);
    fib_len=5;
    pointPos = 1;
    for i=1:numel(tracks.nPoints)
        %stream=tracks(i).matrix;
        if tracks.nPoints(i)>fib_len
            stream = tracks.matrix(pointPos:(pointPos+tracks.nPoints(i)-1), :);
            x=stream(:,1);
            y=stream(:,2);
            z=stream(:,3);
            x_first=stream(1,1);
            x_last=stream(end,1);
            y_first=stream(1,2);
            y_last=stream(end,2);
            z_first=stream(1,3);
            z_last=stream(end,3);
            % x displacement
            xdisp=abs(x_first-x_last);
            % y displacement
            ydisp=abs(y_first-y_last);
            % z displacement
            zdisp=abs(z_first-z_last);
            % relative x displacement
            Rxdisp=xdisp/(xdisp+ydisp+zdisp);
            Rydisp=ydisp/(xdisp+ydisp+zdisp);
            Rzdisp=zdisp/(xdisp+ydisp+zdisp);
            col=[Rxdisp,Rydisp,Rzdisp];
            % plot
            plot3(x,y,z,'LineWidth',1,'Color',col)
            hold on
        end
        pointPos = pointPos+tracks.nPoints(i);
    end    
    
toc
%end addTrack()

% --- Save each surface as a polygon file
function saveMesh(v,varargin)
% filename should be .ply, .vtk or (if SPM installed) .gii
%MATcro('saveMesh',{'myMesh.ply'});
if (length(varargin) < 1), return; end;
filename = char(varargin{1});
doSaveMesh(v,filename)
%end saveMesh()


% --- close all open layers 
function closeLayers(v,varargin)
%MATcro('closeLayers');
doCloseOverlays(v);
%end closeLayers()

% --- set a Layer's color and transparency
function layerRGBA(v,varargin)
% inputs: layerNumber, Red, Green, Blue, Alpha
%MATcro('layerRGBA', 1, 0.9, 0, 0, 0.2) %set layer 1 to bright red (0.9) with 20% opacity
if (length(varargin) < 2), return; end;
vIn = cell2mat(varargin);
v.vprefs.colors(vIn(1),1:(length(varargin)-1)) = vIn(2:length(varargin)); %change layer 1's red/green/blue/opacity 
guidata(v.hMainFigure,v);%store settings
redrawSurface(v);
%end layerRGBA()

% ---  reduce mesh complexity
function simplifyLayers(v, varargin)
% inputs: reductionRatio
%MATcro('simplifyLayers', 0.2); %reduce mesh to 20% complexity
if (length(varargin) < 1), return; end;
reduce = cell2mat(varargin(1));
doSimplifyMesh(v,reduce)
%end simplifyLayers()

% --- set surface appearance (shiny, matte, etc)
function setMaterial(v,varargin)
% inputs: ambient(0..1), diffuse(0..1), specular(0..1), specularExponent(0..inf), bgMode (0 or 1), backFaceLighting (0 or 1)
%MATcro('setMaterial', 0.5, 0.5, 0.7, 100, 1, 1);
if (length(varargin) < 1), return; end;
vIn = cell2mat(varargin);
v.vprefs.materialKaKdKsn(1) = vIn(1);
if (length(varargin) > 1), v.vprefs.materialKaKdKsn(2) = vIn(2); end;
if (length(varargin) > 2), v.vprefs.materialKaKdKsn(3) = vIn(3); end;
v.vprefs.materialKaKdKsn(1:3) = boundArray(v.vprefs.materialKaKdKsn(1:3),0,1);
if (length(varargin) > 3), v.vprefs.materialKaKdKsn(4) = vIn(4); end;
if (length(varargin) > 4), v.vprefs.bgMode = vIn(5); end;
if (length(varargin) > 5), v.vprefs.backFaceLighting = vIn(6); end;
guidata(v.hMainFigure,v);%store settings
redrawSurface(v);
%end setMaterial()

% --- set view by moving camera position
function setView(v,varargin)
% inputs: azimuth(0..360), elevation(=90..90)
%MATcro('setView', 15, 25);
if (nargin < 1), return; end;
vIn = cell2mat(varargin);
v.vprefs.az = vIn(1);
if (nargin > 1), v.vprefs.el = vIn(2); end;
guidata(v.hMainFigure,v);%store settings
redrawSurface(v);
%end setView()

% --- reduce mesh complexity
function doSimplifyMesh(v,reduce)
if (reduce >= 1) || (reduce <= 0), disp('simplify ratio must be between 0..1');  return; end;
for i=1:length(v.surface)
    FVr = reducepatch(v.surface(i),reduce);
    fprintf('Mesh reduced %d->%d vertices and %d->%d faces\n',size(v.surface(i).vertices,1),size(FVr.vertices,1),size(v.surface(i).faces,1),size(FVr.faces,1) );
    v.surface(i).faces = FVr.faces;
    v.surface(i).vertices = FVr.vertices;
    clear('FVr');    
end;
guidata(v.hMainFigure,v);%store settings
redrawSurface(v);
%end simplifyMesh()
    

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

% --- open pre-generated mesh
function meshToOpen (v,filename, isBackground)
if isequal(filename,0), return; end;
if exist(filename, 'file') == 0, fprintf('Unable to find %s\n',filename); return; end;
[~, ~, ext] = fileparts(filename);
if (length(ext) == 4) && strcmpi(ext,'.gii') && (~exist('gifti.m', 'file') == 2)
    fprintf('Unable to open GIfTI files: this feature requires SPM to be installed');
end;
if (isBackground) 
    v = rmfield(v,'surface');
    layer = 1;
else
    layer = length( v.surface)+1;
end;
if (length(ext) == 4) && strcmpi(ext,'.gii')
    gii = gifti(filename);
     v.surface(layer).faces = double(gii.faces); %convert to double or reducepatch fails
     v.surface(layer).vertices = double(gii.vertices); %convert to double or reducepatch fails
else
    [gii.vertices gii.faces] = read_vtkSub(filename);
     v.surface(layer).faces = gii.faces'; 
     v.surface(layer).vertices = gii.vertices'; 
end;
v.vprefs.demoObjects = false;
guidata(v.hMainFigure,v);%store settings
redrawSurface(v);
%end meshToOpen()

% --- clip all values of 'in' to the range min..max
function [out] = boundArray(in, min,max)
out = in;
i = out > max;
out(i) = max;
i = out < min;
out(i) = min;
%end boundArray()

% --- load NIfTI header: mimics spm_vol without requiring SPM
function [Hdr] = spm_volSub(filename)
[h, ~, fileprefix, machine] = load_nii_hdr(filename);
Hdr.dim = [h.dime.dim(2) h.dime.dim(3) h.dime.dim(4)];
if (h.hist.sform_code == 0) && (h.hist.qform_code == 0)
    fprintf('Warning: no spatial transform detected. Perhaps Analyze rather than NIfTI format');
    Hdr.mat = hdr2M(h.dime.dim,h.dime.pixdim );
elseif (h.hist.sform_code == 0) && (h.hist.qform_code > 0) %use qform Quaternion only if no sform
    Hdr.mat = hdrQ2M(h.hist,h.dime.dim,h.dime.pixdim );
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

% --- load NIfTI header
function [hdr, filetype, fileprefix, machine] = load_nii_hdr(fileprefix)
% Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
if ~exist('fileprefix','var'),
  error('Usage: [hdr, filetype, fileprefix, machine] = load_nii_hdr(filename)');
end
machine = 'ieee-le';
new_ext = 0;
if findstr('.nii',fileprefix) & strcmp(fileprefix(end-3:end), '.nii')
  new_ext = 1;
  fileprefix(end-3:end)='';
end
if findstr('.hdr',fileprefix) & strcmp(fileprefix(end-3:end), '.hdr')
  fileprefix(end-3:end)='';
end
if findstr('.img',fileprefix) & strcmp(fileprefix(end-3:end), '.img')
  fileprefix(end-3:end)='';
end
if new_ext
  fn = sprintf('%s.nii',fileprefix);
  if ~exist(fn)
     msg = sprintf('Cannot find file "%s.nii".', fileprefix);
     error(msg);
  end
else
  fn = sprintf('%s.hdr',fileprefix);
  if ~exist(fn)
     msg = sprintf('Cannot find file "%s.hdr".', fileprefix);
     error(msg);
  end
end
fid = fopen(fn,'r',machine); 
if fid < 0,
  msg = sprintf('Cannot open file %s.',fn);
  error(msg);
else
  fseek(fid,0,'bof');
  if fread(fid,1,'int32') == 348
     hdr = read_header(fid);
     fclose(fid);
  else
     fclose(fid);
     %  first try reading the opposite endian to 'machine'
     switch machine,
     case 'ieee-le', machine = 'ieee-be';
     case 'ieee-be', machine = 'ieee-le';
     end
     fid = fopen(fn,'r',machine);
     if fid < 0,
        msg = sprintf('Cannot open file %s.',fn);
        error(msg);
     else
        fseek(fid,0,'bof');
        if fread(fid,1,'int32') ~= 348
           %  Now throw an error
           %
           msg = sprintf('File "%s" is corrupted.',fn);
           error(msg);
        end
        hdr = read_header(fid);
        fclose(fid);
     end
  end
end
if strcmp(hdr.hist.magic, 'n+1')
  filetype = 2;
elseif strcmp(hdr.hist.magic, 'ni1')
  filetype = 1;
else
  filetype = 0;
end
%end load_nii_hdr()

% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
function [ dsr ] = read_header(fid)
dsr.hk   = header_key(fid);
dsr.dime = image_dimension(fid);
dsr.hist = data_history(fid);
if ~strcmp(dsr.hist.magic, 'n+1') && ~strcmp(dsr.hist.magic, 'ni1')
    dsr.hist.qform_code = 0;
    dsr.hist.sform_code = 0;
end
%end read_header()

% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
function [ hk ] = header_key(fid)
fseek(fid,0,'bof');
v6 = version;
if str2num(v6(1))<6
   directchar = '*char';
else
   directchar = 'uchar=>char';
end
hk.sizeof_hdr    = fread(fid, 1,'int32')';	% should be 348!
hk.data_type     = deblank(fread(fid,10,directchar)');
hk.db_name       = deblank(fread(fid,18,directchar)');
hk.extents       = fread(fid, 1,'int32')';
hk.session_error = fread(fid, 1,'int16')';
hk.regular       = fread(fid, 1,directchar)';
hk.dim_info      = fread(fid, 1,'uchar')';
%end header_key()
    
% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
function [ dime ] = image_dimension(fid)
dime.dim        = fread(fid,8,'int16')';
dime.intent_p1  = fread(fid,1,'float32')';
dime.intent_p2  = fread(fid,1,'float32')';
dime.intent_p3  = fread(fid,1,'float32')';
dime.intent_code = fread(fid,1,'int16')';
dime.datatype   = fread(fid,1,'int16')';
dime.bitpix     = fread(fid,1,'int16')';
dime.slice_start = fread(fid,1,'int16')';
dime.pixdim     = fread(fid,8,'float32')';
dime.vox_offset = fread(fid,1,'float32')';
dime.scl_slope  = fread(fid,1,'float32')';
dime.scl_inter  = fread(fid,1,'float32')';
dime.slice_end  = fread(fid,1,'int16')';
dime.slice_code = fread(fid,1,'uchar')';
dime.xyzt_units = fread(fid,1,'uchar')';
dime.cal_max    = fread(fid,1,'float32')';
dime.cal_min    = fread(fid,1,'float32')';
dime.slice_duration = fread(fid,1,'float32')';
dime.toffset    = fread(fid,1,'float32')';
dime.glmax      = fread(fid,1,'int32')';
dime.glmin      = fread(fid,1,'int32')';
%end image_dimension()

% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
function [ hist ] = data_history(fid)
v6 = version;
if str2double(v6(1))<6
   directchar = '*char';
else
   directchar = 'uchar=>char';
end
hist.descrip     = deblank(fread(fid,80,directchar)');
hist.aux_file    = deblank(fread(fid,24,directchar)');
hist.qform_code  = fread(fid,1,'int16')';
hist.sform_code  = fread(fid,1,'int16')';
hist.quatern_b   = fread(fid,1,'float32')';
hist.quatern_c   = fread(fid,1,'float32')';
hist.quatern_d   = fread(fid,1,'float32')';
hist.qoffset_x   = fread(fid,1,'float32')';
hist.qoffset_y   = fread(fid,1,'float32')';
hist.qoffset_z   = fread(fid,1,'float32')';
hist.srow_x      = fread(fid,4,'float32')';
hist.srow_y      = fread(fid,4,'float32')';
hist.srow_z      = fread(fid,4,'float32')';
hist.intent_name = deblank(fread(fid,16,directchar)');
hist.magic       = deblank(fread(fid,4,directchar)');
fseek(fid,253,'bof');
hist.originator  = fread(fid, 5,'int16')';
%end data_history()

% --- guess orientation: only use when neither sform or qform is available
function M = hdr2M(dim, pixdim)
%from SPM decode_qform0 Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging, GPL
n      = min(dim(1),3);
vox    = [pixdim(2:(n+1)) ones(1,3-n)];
x = (dim(2:4)+1)/2;
off     = -vox.*origin;
M       = [vox(1) 0 0 off(1) ; 0 vox(2) 0 off(2) ; 0 0 vox(3) off(3) ; 0 0 0 1];
%end hdr2M()

% --- Rotations from quaternions
function M = hdrQ2M(hdr, dim, pixdim)
%from SPM decode_qform0 Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging, GPL
R = Q2M(double([hdr.quatern_b hdr.quatern_c hdr.quatern_d]));
T = [eye(4,3) double([hdr.qoffset_x hdr.qoffset_y hdr.qoffset_z 1]')];
n = min(dim(1),3);
Z = [pixdim(2:(n+1)) ones(1,4-n)];
Z(Z<0) = 1;
if pixdim(1)<0, Z(3) = -Z(3); end;
Z = diag(Z);
M = T*R*Z;
M = M
%end hdrQ2M()

% --- Generate a rotation matrix from a quaternion xi+yj+zk+w,
function M = Q2M(Q)
%from SPM decode_qform0 Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging, GPL
% where Q = [x y z], and w = 1-x^2-y^2-z^2.
% See: http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation#Conversion_to_and_from_the_matrix_representation
Q = Q(1:3); % Assume rigid body
w = sqrt(1 - sum(Q.^2));
x = Q(1); y = Q(2); z = Q(3);
if w<1e-7,
    w = 1/sqrt(x*x+y*y+z*z);
    x = x*w;
    y = y*w;
    z = z*w;
    w = 0;
end;
xx = x*x; yy = y*y; zz = z*z; ww = w*w;
xy = x*y; xz = x*z; xw = x*w;
yz = y*z; yw = y*w; zw = z*w;
M = [...
(xx-yy-zz+ww)      2*(xy-zw)      2*(xz+yw) 0
    2*(xy+zw) (-xx+yy-zz+ww)      2*(yz-xw) 0
    2*(xz-yw)      2*(yz+xw) (-xx-yy+zz+ww) 0
           0              0              0  1];
%end Q2M()

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

% --- read VTK format mesh
function [vertex,face] = read_vtkSub(filename)
%   [vertex,face] = read_vtk(filename);
%   'vertex' is a 'nb.vert x 3' array specifying the position of the vertices.
%   'face' is a 'nb.face x 3' array specifying the connectivity of the mesh.
%   Copyright (c) Mario Richtsfeld, distributed under BSD license
% http://www.mathworks.com/matlabcentral/fileexchange/5355-toolbox-graph/content/toolbox_graph/read_vtk.m
fid = fopen(filename,'r');
if( fid==-1 )
    error('Can''t open the file.');
    return;
end
str = fgets(fid);   % -1 if eof
if ~strcmp(str(3:5), 'vtk')
    error('The file is not a valid VTK one.');    
end
% read header
str = fgets(fid);
str = fgets(fid);
str = fgets(fid);
str = fgets(fid);
nvert = sscanf(str,'%*s %d %*s', 1);
% read vertices
[A,cnt] = fscanf(fid,'%f %f %f', 3*nvert);
if cnt~=3*nvert
    warning('Problem in reading vertices.');
end
A = reshape(A, 3, cnt/3);
vertex = A;
% read polygons
str = fgets(fid);
str = fgets(fid);
info = sscanf(str,'%c %*s %*s', 1);
if((info ~= 'P') && (info ~= 'V'))
    str = fgets(fid);    
    info = sscanf(str,'%c %*s %*s', 1);
end
if(info == 'P')
        nface = sscanf(str,'%*s %d %*s', 1);
    [A,cnt] = fscanf(fid,'%d %d %d %d\n', 4*nface);
    if cnt~=4*nface
        warning('Problem in reading faces.');
    end
    A = reshape(A, 4, cnt/4);
    face = A(2:4,:)+1;
end
if(info ~= 'P')
    face = 0;
end
% read vertex indices
if(info == 'V')
    nv = sscanf(str,'%*s %d %*s', 1);
    [A,cnt] = fscanf(fid,'%d %d \n', 2*nv);
    if cnt~=2*nv
        warning('Problem in reading faces.');
    end
    A = reshape(A, 2, cnt/2);
    face = repmat(A(2,:)+1, 3, 1);
end
if((info ~= 'P') && (info ~= 'V'))
    face = 0;
end
fclose(fid);
%end read_vtkSub()

% --- threshold for converting continuous brightness to binary image using Otsu's method.
function [thresh] = otsuSub(I)
% BSD license: http://www.mathworks.com/matlabcentral/fileexchange/26532-image-segmentation-using-otsu-thresholding
% Damien Garcia 2010/03 http://www.biomecardio.com/matlab/otsu.html
nbins = 256;
if (min(I(:)) == max(I(:)) ), disp('otu error: no intensity variability'); thresh =min(I(:)); return; end; 
intercept = min(I(:)); %we will translate min-val to be zero
slope = (nbins-1)/ (max(I(:))-intercept); %we will scale images to range 0..(nbins-1)
%% Convert to 256 levels
I = round((I - intercept) * slope);
%% Probability distribution
[histo,pixval] = hist(I(:),256);
P = histo/sum(histo);
%% Zeroth- and first-order cumulative moments
w = cumsum(P);
mu = cumsum((1:nbins).*P);
sigma2B =(mu(end)*w(2:end-1)-mu(2:end-1)).^2./w(2:end-1)./(1-w(2:end-1));
[maxsig,k] = max(sigma2B);
thresh=    pixval(k+1);
if (thresh >= nbins), thresh = nbins-1; end;
thresh = thresh/slope + intercept;
%end otsuSub()
