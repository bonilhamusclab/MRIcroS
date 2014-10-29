%test basic functions : seen when 'help MRIcroS' is called  
MRIcroS %launch MRIcroS
MRIcroS('addLayer','lh.pial'); %open image
MRIcroS('simplifyMeshes', 0.5); %reduce mesh to 50% complexity
MRIcroS('closeLayers'); %close all volume images
MRIcroS('addLayer','BrainMesh_ICBM152.nv'); %open image
MRIcroS('addLayer','motor.nii.gz',1,0, 3.0); %add fMRI overlay, threshold t>3
MRIcroS('addLayer','invMotor.ply'); %add another fMRI (already a mesh)
for i=-27:9
    MRIcroS('setView', i*10, 35); %rotate azimuth, constant elevation
    pause(0.1);
end;
MRIcroS('copyBitmap'); %copy screenshot to clipboard
MRIcroS('saveBitmap','myPicture.png'); %save screenshot
MRIcroS('saveMesh','myMesh.ply'); %export mesh to PLY format
MRIcroS('closeAllItems') 
MRIcroS('addLayer','stroke.mat') 
MRIcroS('addTrack','stroke.trk',1,9) 
MRIcroS('clipMesh',1,[-inf -inf -inf], [inf inf 30]) 
MRIcroS('vertexColorBrightness',1,0.5,1,3) %make layer 1 opaque (1.0), same brightness but blue color map
MRIcroS('closeAllItems'); 
MRIcroS('addLayer','BrainMesh_ICBM152.nv'); %open image
MRIcroS('addNodes', 'Node_Brodmann82.node', 'Edge_Brodmann82.edge');
MRIcroS('closeAllItems'); 
MRIcroS('addLayer','mni152_2009.mat'); %open image
MRIcroS('addLayer','invMotor.ply'); %add another fMRI (already a mesh)
MRIcroS('closeAllItems'); 
MRIcroS('addLayer','BrainMesh_ICBM152.nv'); %open image
MRIcroS('addNodes','myNodes.node'); %add hot spots
MRIcroS('layerRGBA',1,0.9,0.6,0.6,0.7); %make layer 1 pink and translucent
MRIcroS('closeAllItems');
MRIcroS('addLayer', 'BrainMesh_ICBM152.nv');
MRIcroS('simplifyMeshes', 0.1); %reduce mesh to 10% complexity
MRIcroS('layerProjectVolume', 1, 'motor.nii.gz', 3, 2, 0.5, 0, 'jet', 'spline');

%test missing parameters
MRIcroS('addLayer','motor.nii.gz');
MRIcroS('addLayer','motor.nii.gz', '', 3);
MRIcroS('addLayer','motor.nii.gz', 'smooth', 3);

MRIcroS('closeAllItems');
MRIcroS('addLayer','motor.nii.gz', '', '', '');

MRIcroS('addTrack','stroke.trk', '', 20);
MRIcroS('addTrack','stroke.trk', 'fiberLengthThreshold', 20);

MRIcroS('addNodes', 'Node_Brodmann82.node', '','','','hsv');
MRIcroS('addNodes', 'Node_Brodmann82.node', '','','','');
MRIcroS('closeNodes');
MRIcroS('addNodes', 'Node_Brodmann82.node', 'Edge_Brodmann82.edge','','','hsv');


MRIcroS('layerRGBA', 1, '', '', .9);
MRIcroS('layerRGBA', 1, '', '', '');
MRIcroS('layerRGBA', 1, 'b', .8);

MRIcroS('projectVolume', 1, 'stroke.nii.gz', '', '', '', '');
MRIcroS('closeProjections');
MRIcroS('projectVolume', 1, 'stroke.nii.gz', '','','', 'autumn', '', 'spline');

MRIcroS('setMaterial', '','','','','');
MRIcroS('setMaterial', 'backFaceLighting',0);
