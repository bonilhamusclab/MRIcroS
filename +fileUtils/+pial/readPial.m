function [faces, vertices] = readPial(fileName)
% function [faces, vertices] = readPial(fileName)
%inputs:
%	fileName: the freesurfer pial file to open
%notes
% filenames often do not have '.pial' extension
% we can detect the file by reading the first 8 bytes for a magic signature
% http://www.grahamwideman.com/gw/brain/fs/surfacefileformats.htm 
%
%outputs:
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix
fid = fopen(fileName, 'rb', 'b') ;
%vertices
magic = fread(fid, 1, 'int64') ;
if magic ~= -1771902246540 %3 byte signature + 'creat'
    fclose(fid);
    faces = [];
    vertices = [];
    return;
end
fgets(fid);
fgets(fid);
num_v = fread(fid, 1, 'int32') ;
num_f = fread(fid, 1, 'int32') ;
vertices= fread(fid, [3 num_v], 'float32');
faces= fread(fid, [3 num_f], 'int32') + 1;
vertices = vertices';
faces = faces';
fclose(fid);
%end readPial()
