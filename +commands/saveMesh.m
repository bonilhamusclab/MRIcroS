% --- Save each surface as a polygon file
function saveMesh(v,varargin)
% filename should be .ply, .vtk or (if SPM installed) .gii
%MATcro('saveMesh',{'myMesh.ply'});
if (length(varargin) < 1), return; end;
filename = char(varargin{1});
fileUtils.saveMesh(v,filename)
%end saveMesh()
