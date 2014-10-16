function [faces, vertices] = readNv(fileName)
%function [faces, vertices] = readNv(fileName)
%inputs:
%	fileName: the nv file to open
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

faces = g.faces;
vertices = g.vertices;
%end readNv()