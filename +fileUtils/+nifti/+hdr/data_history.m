% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
function [ hist ] = data_history(fid)
v6 = version;
if str2double(v6(1))<6
   directchar = '*char';
else
   directchar = 'uchar=>char';
end
hist.descrip     = deblank(fread(fid,80,directchar)');
hist.aux_file    = deblank(fread(fid,24,directchar)');
hist.qform_code  = fread(fid,1,'int16')';
hist.sform_code  = fread(fid,1,'int16')';
hist.quatern_b   = fread(fid,1,'float32')';
hist.quatern_c   = fread(fid,1,'float32')';
hist.quatern_d   = fread(fid,1,'float32')';
hist.qoffset_x   = fread(fid,1,'float32')';
hist.qoffset_y   = fread(fid,1,'float32')';
hist.qoffset_z   = fread(fid,1,'float32')';
hist.srow_x      = fread(fid,4,'float32')';
hist.srow_y      = fread(fid,4,'float32')';
hist.srow_z      = fread(fid,4,'float32')';
hist.intent_name = deblank(fread(fid,16,directchar)');
hist.magic       = deblank(fread(fid,4,directchar)');
fseek(fid,253,'bof');
hist.originator  = fread(fid, 5,'int16')';
%end data_history()
