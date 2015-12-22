function [faces, vertices, vertexColors] = readMz3(filename)
%function [faces, vertices, vertexColors] = readMz3(fileName)
%inputs:
%	filename: the nv file to open
%outputs:
%	faces: face matrix where cols are xyz and each row is face
%	vertices: vertices matrix where cols are xyz and each row a vertix
%Mz3 is the native format of Surf Ice, it is small and fast to read

%if ~exist('filename','var'), filename = 'stroke.mz3'; end;
faces = [];
vertices = [];
vertexColors = [];
if ~exist(filename,'file'), return; end;
%Decode gzip data
% http://undocumentedmatlab.com/blog/savezip-utility
% http://www.mathworks.com/matlabcentral/fileexchange/39526-byte-encoding-utilities/content/encoder/gzipdecode.m
streamCopier = com.mathworks.mlwidgets.io.InterruptibleStreamCopier.getInterruptibleStreamCopier;
baos = java.io.ByteArrayOutputStream;
fis  = java.io.FileInputStream(filename);
zis  = java.util.zip.GZIPInputStream(fis);
streamCopier.copyStream(zis,baos);
fis.close;
data = baos.toByteArray;
%mz3 ALWAYS little endian
machine = 'ieee-le';
magic = typecast(data(1:4),'uint32');
if magic ~= 3365453, fprintf('Signature is not MZ3\n'); return; end;
%attr reports attributes and version 
attr = typecast(data(5:8),'uint32');
if (attr == 0) || (attr > 7), fprintf('Unsupported version\n'); end;
isFace = bitand(attr,1);
isVert = bitand(attr,2);
isRGBA = bitand(attr,4);
%read attributes
nFace = typecast(data(9:12),'uint32');
nVert = typecast(data(13:16),'uint32');
nRGBA = typecast(data(17:20),'uint32');
nSkip = typecast(data(21:24),'uint32');
hdrSz = 24+nSkip; %header size in bytes
%read faces
facebytes = nFace * 3 * 4; %each face has 3 indices, each 4 byte int
faces = typecast(data(hdrSz+1:hdrSz+facebytes),'int32');
faces = double(faces')+1; %matlab indices arrays from 1 not 0
faces = reshape(faces,3,nFace)';
hdrSz = hdrSz + facebytes;
%read vertices
vertbytes = nVert * 3 * 4; %each vertex has 3 values (x,y,z), each 4 byte float
vertices = typecast(data(hdrSz+1:hdrSz+vertbytes),'single');
vertices = double(vertices); %matlab wants doubles
vertices = reshape(vertices,nVert,3);
hdrSz = hdrSz + vertbytes;
if nRGBA < 1, return; end;

%read vertexColors
RGBAbytes = nVert * 4; %each color has 4 values (r,g,b,a), each 1 byte
vertexColors = typecast(data(hdrSz+1:hdrSz+RGBAbytes),'uint8');
vertexColors = double(vertexColors)/255; %matlab wants values 0..1
v = reshape(vertexColors,nVert,4);
vertexColors = reshape(vertexColors,nVert,4);
vertexColors = vertexColors(:,1:3);
%end readMz3()