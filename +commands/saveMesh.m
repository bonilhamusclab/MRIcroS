function saveMesh(v,varargin)
% filename should be .ply, .vtk or (if SPM installed) .gii
%MRIcroS('saveMesh',{'myMesh.ply'});
% --- Save each surface as a polygon file
if (length(varargin) < 1), return; end;
filename = char(varargin{1});
fileUtils.saveMesh(v,filename)
%end saveMesh()
