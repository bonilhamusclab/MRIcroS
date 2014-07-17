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
