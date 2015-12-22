function writeNv(vertex,face,filename)
%function writeNv(vertex,faces,filename)
% --- save Face/Vertex data as BrainNet format file
%inputs:
%	fileName: the nv file to create
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix
%Note: very similar to VTK text format
[nF nFd] =size(face);
[nV nVd] =size(vertex);
if (nF <1) || (nV <3 || (nFd ~=3) || (nVd ~=3)), warning('Problem with writeNv'); return; end; 
fid = fopen(filename, 'wt');
fprintf(fid, '# BrainNet format image created with MRIcroS\n');
fprintf(fid, '%d\n',nV);
fprintf(fid, '%.12g %.12g %.12g\n', vertex');
fprintf(fid, '%d\n',nF);
fprintf(fid, '%d %d %d\n', (face)');
fclose(fid);
%end writeNv()
