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
%MRIcroS('closeProjections');
MRIcroS('projectVolume', 1, 'stroke.nii.gz', 'colorMap', 2, 'interpMethod', 'spline');

MRIcroS('setMaterial', '','','','','');
MRIcroS('setMaterial', 'backFaceLighting',0);
