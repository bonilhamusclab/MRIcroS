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
h = findall(0,'Tag','makeGui'); %run as singleton
if (isempty(h)) % new instance
   h = gui.makeGui(); %set up user interface
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

function openLayer(v, varargin)
	doOpenLayer(v, varargin)

function copyBitmap(v)
	doCopyBitmap(v)

function saveBitmap(v,varargin)
	fileUtils.saveBitmap(v, varargin)
% end saveBitmap()

% --- Save each surface as a polygon file
function saveMesh(v,varargin)
% filename should be .ply, .vtk or (if SPM installed) .gii
%MATcro('saveMesh',{'myMesh.ply'});
if (length(varargin) < 1), return; end;
filename = char(varargin{1});
fileUtils.doSaveMesh(v,filename)
%end saveMesh()

function addTrack(v, varargin)	
	if (length(varargin) < 1), return; end;
	filename = char(varargin{1});
	fileUtils.trk.addTrack(v, filename)
%end addTrack()

% --- close all open layers 
function closeLayers(v,varargin)
%MATcro('closeLayers');
doCloseOverlays(v);
%end closeLayers()

% --- set a Layer's color and transparency
function layerRGBA(v,varargin)
% inputs: layerNumber, Red, Green, Blue, Alpha
%MATcro('layerRGBA', 1, 0.9, 0, 0, 0.2) %set layer 1 to bright red (0.9) with 20% opacity
doSetLayerRgba(v, varargin)
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
function simplifyMesh(v, reduce)
	doSimplifyMesh(v, reduce)
%end simplifyMesh()


% --- clip all values of 'in' to the range min..max
function [out] = boundArray(in, min,max)
out = in;
i = out > max;
out(i) = max;
i = out < min;
out(i) = min;
%end boundArray()

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
