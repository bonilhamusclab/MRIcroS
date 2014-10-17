function saveMesh(v,filename)
% filename should be .ply, .vtk or (if SPM installed) .gii
%MRIcroS('saveMesh','myMesh.ply');
% --- Save each surface as a polygon file
fileUtils.saveMesh(v,filename)
%end saveMesh()
