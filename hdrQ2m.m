% --- Rotations from quaternions
function M = hdrQ2M(hdr, dim, pixdim)
%from SPM decode_qform0 Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging, GPL
R = Q2M(double([hdr.quatern_b hdr.quatern_c hdr.quatern_d]));
T = [eye(4,3) double([hdr.qoffset_x hdr.qoffset_y hdr.qoffset_z 1]')];
n = min(dim(1),3);
Z = [pixdim(2:(n+1)) ones(1,4-n)];
Z(Z<0) = 1;
if pixdim(1)<0, Z(3) = -Z(3); end;
Z = diag(Z);
M = T*R*Z;
M = M
%end hdrQ2M()
