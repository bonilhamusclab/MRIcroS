function [ hk ] = header_key(fid)
% --- read NIfTI header, Copyright (c) 2009, Jimmy Shen, 2-clause FreeBSD License
fseek(fid,0,'bof');
v6 = version;
if str2num(v6(1))<6
   directchar = '*char';
else
   directchar = 'uchar=>char';
end
hk.sizeof_hdr    = fread(fid, 1,'int32')';	% should be 348!
hk.data_type     = deblank(fread(fid,10,directchar)');
hk.db_name       = deblank(fread(fid,18,directchar)');
hk.extents       = fread(fid, 1,'int32')';
hk.session_error = fread(fid, 1,'int16')';
hk.regular       = fread(fid, 1,directchar)';
hk.dim_info      = fread(fid, 1,'uchar')';
%end header_key()
