function [faces, vertices] = readNv(fileName, patchReductionFactor)
%function [faces, vertices] = readNv(fileName)
%inputs:
%	fileName: the nv file to open
%	patchReductionFactor: optional param specifying whether to reduce faces
%		if not specified .1 reduction performed
%		if specified as 1, no processing performed
%outputs:
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix

fid=fopen(fileName);

num_v=fscanf(fid,'%f',1);
coord=fscanf(fid,'%f',[3,num_v]);
num_tri=fscanf(fid,'%f',1);
tri=fscanf(fid,'%d',[3,num_tri]);

fclose(fid);

g.faces=tri';
g.vertices=coord';

if(nargin == 1)
	patchReductionFactor = .1;
end

if(patchReductionFactor ~= 1)
	tic
	g=reducepatch(g, 0.1);
	toc
end

faces = g.faces;
vertices = g.vertices;
