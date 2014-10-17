function varargout = MRIcroS(varargin)
% surface rendering for NIfTI images, can be run from user interface or scripted
%Examples:
% MRIcroS %launch MRIcroS
% MRIcroS('addLayer','lh.pial'); %open image
% MRIcroS('simplifyMeshes', 0.5); %reduce mesh to 50% complexity
% MRIcroS('closeLayers'); %close all volume images
% MRIcroS('addLayer','BrainMesh_ICBM152.nv'); %open image
% MRIcroS('addLayer','motor.nii.gz',1,0, 3.0); %add fMRI overlay, threshold t>3
% MRIcroS('addLayer','invMotor.ply'); %add another fMRI (already a mesh)
% for i=-27:9
% 	MRIcroS('setView', i*10, 35); %rotate azimuth, constant elevation
% 	pause(0.1);
% end;
% MRIcroS('copyBitmap'); %copy screenshot to clipboard
% MRIcroS('saveBitmap','myPicture.png'); %save screenshot
% MRIcroS('saveMesh','myMesh.ply'); %export mesh to PLY format
% MRIcroS('closeAllItems') 
% MRIcroS('addLayer','stroke.trib') 
% MRIcroS('addTrack','stroke.trk',1,9) 
% MRIcroS('clipMesh',1,[-inf -inf -inf], [inf inf 30]) 
% MRIcroS('layerRGBA', 1, 0.9, 0, 0, 1.0, 0.35) %layer1 alpha=1.0, bias=0.35
% MRIcroS('closeAllItems'); %close all rendered items
% MRIcroS('addLayer','BrainMesh_ICBM152.nv'); %open image
% MRIcroS('addNodes', 'Node_Brodmann82.node', 'Edge_Brodmann82.edge');

mOutputArgs = {}; % Variable for storing output when GUI returns
h = gui.getGuiHandle(); 
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
