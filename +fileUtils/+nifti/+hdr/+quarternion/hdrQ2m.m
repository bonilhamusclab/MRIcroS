% --- Rotations from quaternions
function M = hdrQ2m(hdr, dim, pixdim)
%from SPM decode_qform0 Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging, GPL
R = q2mSub(double([hdr.quatern_b hdr.quatern_c hdr.quatern_d]));
T = [eye(4,3) double([hdr.qoffset_x hdr.qoffset_y hdr.qoffset_z 1]')];
n = min(dim(1),3);
Z = [pixdim(2:(n+1)) ones(1,4-n)];
Z(Z<0) = 1;
if pixdim(1)<0, Z(3) = -Z(3); end;
Z = diag(Z);
M = T*R*Z;
%end hdrQ2m()


% --- Generate a rotation matrix from a quaternion xi+yj+zk+w,
function M = q2mSub(Q)
%from SPM decode_qform0 Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging, GPL
% where Q = [x y z], and w = 1-x^2-y^2-z^2.
% See: http://en.wikipedia.org/wiki/Quaternions_and_spatial_rotation#Conversion_to_and_from_the_matrix_representation
Q = Q(1:3); % Assume rigid body
w = sqrt(1 - sum(Q.^2));
x = Q(1); y = Q(2); z = Q(3);
if w<1e-7,
    w = 1/sqrt(x*x+y*y+z*z);
    x = x*w;
    y = y*w;
    z = z*w;
    w = 0;
end;
xx = x*x; yy = y*y; zz = z*z; ww = w*w;
xy = x*y; xz = x*z; xw = x*w;
yz = y*z; yw = y*w; zw = z*w;
M = [...
(xx-yy-zz+ww)      2*(xy-zw)      2*(xz+yw) 0
    2*(xy+zw) (-xx+yy-zz+ww)      2*(yz-xw) 0
    2*(xz-yw)      2*(yz+xw) (-xx-yy+zz+ww) 0
           0              0              0  1];
%end q2mSub()
