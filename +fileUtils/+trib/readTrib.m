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
if ~exist(fileName,'file') || (info.bytes < 92) 
    error('File to small to be in trib format %s', fileName);
end
%(1) decompress data
%http://undocumentedmatlab.com/blog/savezip-utility
streamCopier = com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
baos = java.io.ByteArrayOutputStream;
fis  = java.io.FileInputStream(fileName);
zis  = java.util.zip.GZIPInputStream(fis);
streamCopier.copyStream(zis,baos);
fis.close;
data = baos.toByteArray;
SIG = typecast(data(1:4),'int32'); %file signature
if (SIG ~= 169478669)
    error('File is not in trib format %d %s',SIG, fileName);
end
NTRI = typecast(data(5:8),'int32');
NVERT = typecast(data(9:12),'int32');
NCOLOR = typecast(data(13:16),'int32'); %number of colors
COLORTABLE = typecast(data(17:20),'int32'); %COLORTABLE
colorMap = utils.colorTables(COLORTABLE);
UNUSED1 = typecast(data(21:24),'int32'); %#ok<NASGU> %UNUSED1
colorMin = typecast(data(25:28),'single'); %COLORMIN
if (colorMin >= 1), colorMin = 0; end;
colorMin = utils.boundArray(colorMin,0,0.95);
UNUSED1 = typecast(data(29:32),'single'); %#ok<NASGU> %UNUSED3
expectedBytes = 32 + (12 * NTRI) + (12 * NVERT) + (4 * NVERT * NCOLOR);   %header + tri + vert + color
if (numel(data) ~= expectedBytes) 
    fprintf('readTrib error: expected %d instead of %d bytes, nTRI=%d nVERT=%d nCOLOR=%d %s\n',expectedBytes, info.bytes, NTRI, NVERT, NCOLOR, fileName);
end
%faces = fread(fid,[NTRI 3],'int32'); %read triangle indices
hdrBytes = 32; %the header we just read is 32 bytes long
faceBytes = NTRI * 3 * 4; %x3 int32 values per triangle (indices for triangles)
faces = typecast(data(hdrBytes+1:hdrBytes+faceBytes),'int32'); %read triangle indices
faces = reshape(faces, NTRI, 3);
if (min(faces(:)) < 1) || (max(faces(:)) > NVERT) 
    fprintf('readTrib error: vertex indices must be in the range 1..%d (indexed from 1, not 0)\n',NVERT);
end
vertBytes = NVERT * 3 * 4; %x3 single values per vertex (X,Y,Z)
%vertices = fread(fid,[NVERT 3],'float32'); %read triangle indices
vertices = typecast(data(hdrBytes+faceBytes+1:hdrBytes+faceBytes+vertBytes),'single'); %read triangle indices
vertices = reshape(vertices, NVERT, 3);
if sum(~isfinite(vertices(:))) > 0 %values such as nan, -inf, inf indicate corrupted file
   fprintf('readTrib error: all vertex coordinates should be finite values\n'); 
end
if (NCOLOR > 0)
    clrBytes = NVERT * NCOLOR * 4; %NCOLOR single values per vertex (e.g. 1=Magnitude, 3=RGB)
    %vertexColors = fread(fid,[NVERT NCOLOR],'float32'); %read color of vertex
    vertexColors = typecast(data(hdrBytes+faceBytes+vertBytes+1:hdrBytes+faceBytes+vertBytes+clrBytes),'single'); %read triangle indices
    vertexColors = reshape(vertexColors, NVERT, NCOLOR);
end
faces = double(faces);
vertices = double(vertices);
vertexColors = double(vertexColors);
%fclose(fid);
%end readTrib()