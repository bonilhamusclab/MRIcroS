function [faces, vertices, vertexColors, colorMap, colorMin] = readTrib(fileName)
%Load a binary triangle format file, see writeTrib for format details
%inputs:
%	fileName: the trib file to open
%outputs:
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix
%   vertexColors: colors for each vertex

vertexColors = []; %add vertexColors
info = dir(fileName);
if (info.bytes < 92) 
    error('File to small to be in trib format %s', fileName);
end

fid=fopen(fileName,'rb','l');
SIG = fread(fid,1,'int32'); %file signature
if (SIG ~= 169478669)
    error('File is not in trib format %d %s',SIG, fileName);
end
NTRI = fread(fid,1,'int32'); %number of triangles
NVERT = fread(fid,1,'int32'); %number of vertices
NCOLOR = fread(fid,1,'int32'); %number of colors
COLORTABLE = fread(fid,1,'int32'); %COLORTABLE
colorMap = utils.colorTables(COLORTABLE);
UNUSED1 = fread(fid,1,'int32'); %#ok<NASGU> %UNUSED1
colorMin = fread(fid,1,'float32'); %COLORMIN
if (colorMin >= 1), colorMin = 0; end;
colorMin = utils.boundArray(colorMin,0,0.95);
UNUSED1 = fread(fid,1,'float32'); %#ok<NASGU> %UNUSED3
expectedBytes = 32 + (12 * NTRI) + (12 * NVERT) + (4 * NVERT * NCOLOR);   %header + tri + vert + color
info = dir(fileName);
if (info.bytes ~= expectedBytes) 
    fprintf('readTrib error: expected %d instead of %d bytes, nTRI=%d nVERT=%d nCOLOR=%d %s\n',expectedBytes, info.bytes, NTRI, NVERT, NCOLOR, fileName);
end
faces = fread(fid,[NTRI 3],'int32'); %read triangle indices
if (min(faces(:)) < 1) || (max(faces(:)) > NVERT) 
    fprintf('readTrib error: vertex indices must be in the range 1..%d (indexed from 1, not 0)\n',NVERT);
end
vertices = fread(fid,[NVERT 3],'float32'); %read triangle indices
if sum(~isfinite(vertices(:))) > 0 %values such as nan, -inf, inf indicate corrupted file
   fprintf('readTrib error: all vertex coordinates should be finite values\n'); 
end
if (NCOLOR > 0)
    vertexColors = fread(fid,[NVERT NCOLOR],'float32'); %read color of vertex    
end

fclose(fid);
%end readTrib()