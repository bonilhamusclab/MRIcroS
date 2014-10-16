function [faces, vertices] = readPial(fileName)
% function [faces, vertices] = readPial(fileName, patchReductionFactor)
%inputs:
%	fileName: the nv file to open
%	patchReductionFactor: optional param specifying whether to reduce faces
%		if not specified .1 reduction performed
%		if specified as 1, no processing performed
%outputs:
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix

fid = fopen(fileName, 'rb', 'b') ;
fgets(fid);
fgets(fid);
num_v = fread(fid, 1, 'int32') ;
num_f = fread(fid, 1, 'int32') ;
vertices= fread(fid, [3 num_v], 'float32');
faces= fread(fid, [3 num_f], 'int32') + 1;
vertices = vertices';
faces = faces';
fclose(fid) ;
%end readPial()
