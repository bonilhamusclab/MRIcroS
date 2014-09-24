function varargout = MRIcroS(varargin)
% surface rendering for NIfTI images, can be run from user interface or scripted
%Examples:
% MRIcroS %launch MRIcroS
% MRIcroS('openLayer',{'avg152T1_brain.nii.gz'}); %open image
% MRIcroS('simplifyMeshes', 0.5); %reduce mesh to 50% complexity
% MRIcroS('closeImages'); %close all volume images
% MRIcroS('openLayer',{'cortex_20484.surf.gii'}); %open image
% MRIcroS('openLayer',{'attention.nii.gz'}, 3.0); %add fMRI overlay, threshold t>3
% MRIcroS('openLayer',{'saccades.nii.gz'}, 3.0); %add fMRI overlay threshold t>3
% MRIcroS('openLayer',{'scalp_2562.surf.gii'}); %add scalp overlay
% MRIcroS('layerRGBA', 4, 0.9, 0.5, 0.5, 0.2); %make scalp reddish
% MRIcroS('setMaterial', 0.1, 0.4, 0.9, 50, 0, 1); %make surfaces shiny
% for i=-27:9
% 	MRIcroS('setView', i*10, 35); %rotate azimuth, constant elevation
% 	pause(0.1);
% end;
% MRIcroS('copyBitmap'); %copy screenshot to clipboard
% MRIcroS('saveBitmap',{'myPicture.png'}); %save screenshot
% MRIcroS('saveMesh',{'myMesh.ply'}); %export mesh to PLY format
% MRIcroS('addTrack','myTrack.trk');
% MRIcroS('addTrack','myTrack.trk',trackSpacing,minLength);
% MRIcroS('closeTracks');
% MRIcroS('addBrainNet', node_path, edge_path);
% MRIcroS('closeBrainNets');
% MRIcroS('closeAllItems'); %close all rendered items
mOutputArgs = {}; % Variable for storing output when GUI returns
h = findall(0,'Tag','makeGui'); %run as singleton
if (isempty(h)) % new instance
   h = gui.makeGui(); %set up user interface
else % instance already running
   figure(h);  %Figure exists so bring Figure to the focus
end;
if (nargin) && (ischar(varargin{1})) 
 funcName = varargin{1};
 f = str2func(strcat('commands.', funcName));
 f(guidata(h),varargin{2:nargin})
end
mOutputArgs{1} = h;% return handle to main figure
if nargout>0
 [varargout{1:nargout}] = mOutputArgs{:};
end
%end MRIcroS()
