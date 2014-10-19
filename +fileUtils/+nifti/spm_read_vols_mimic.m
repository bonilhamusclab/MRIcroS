function [img] = spm_read_vols_mimic(hdr)
% --- load NIfTI voxel data: mimics spm_read_vol without requiring SPM
if (exist(hdr.fname, 'file') ~= 2)
    fprintf('Error: unable to find %s', hdr.fname);
    return;
end;
switch hdr.dt(1)
   case   2,
      bitpix = 8;  myprecision = 'uint8';
   case   4,
      bitpix = 16; myprecision = 'int16';
   case   8,
      bitpix = 32; myprecision = 'int32';
   case  16,
      bitpix = 32; myprecision = 'float32';
   case  64,
      bitpix = 64; myprecision = 'float64';
   case 512 
      bitpix = 16; myprecision = 'uint16';
   case 768 
      bitpix = 32; myprecision = 'uint32';
   otherwise
      error('This datatype is not supported'); 
end
myvox = hdr.dim(1)*hdr.dim(2)*hdr.dim(3);
%ensure file is large enough
file_stats = dir(hdr.fname);
imgbytes = (myvox * (bitpix/8))+hdr.pinfo(3); %image bytes plus offset
if (imgbytes > file_stats.bytes)
    fprintf('Error: expected %d but file has %d bytes %s',imgbytes, file_stats.bytes,hdr.fname);
    return;
end;
%read data
fid = fopen(hdr.fname,'r');
if  (hdr.dt(2) == 0)
    myformat = 'l'; %little-endian
else
    myformat = 'b'; %big-endian
end;    
fseek(fid, hdr.pinfo(3), 'bof');
img = fread(fid, myvox, myprecision, 0, myformat);
img = img(:).*hdr.pinfo(1)+hdr.pinfo(2); %apply scale slope and intercept
img = reshape(img,hdr.dim(1),hdr.dim(2),hdr.dim(3));
fclose(fid);
%end spm_read_vols_mimic()
