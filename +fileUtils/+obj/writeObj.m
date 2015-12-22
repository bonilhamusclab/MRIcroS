function writeObk(vertex,face,filename)
%function writeObj(vertex,faces,filename)
% --- save Face/Vertex data as WaveFront Object format file
%inputs:
%	vertex: vertices matrix where cols are xyz and each row a vertix
%	face: face matrix where cols are xyz and each row is face
%	fileName: the Wavefront Object file to create
%notes
% https://en.wikipedia.org/wiki/Wavefront_.obj_file

[nF nFd] =size(face);
[nV nVd] =size(vertex);
if (nF <1) || (nV <3 || (nFd ~=3) || (nVd ~=3)), warning('Problem with writeObj'); return; end; 
fid = fopen(filename, 'wt');
fprintf(fid, '# WaveFront Object format image created with MRIcroS\n');
fprintf(fid, 'v %.12g %.12g %.12g\n', vertex');
fprintf(fid, 'f %d %d %d\n', (face)');
fclose(fid);
%end writeObj()