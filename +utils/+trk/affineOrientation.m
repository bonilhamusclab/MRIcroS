function RASLPI = affineOrientation( affMatrix )
%function RASLPI = affineOrientation( affMatrix )
%   returns implied label (LPS, LAS, etc...)  based on affMatrix
%Similar function to nibabel orientations
%   https://github.com/nipy/nibabel/blob/master/nibabel/orientations.py
%inspired by Xiangrui Li's dicm2nii

R = affMatrix;
if numel(R) >= 16
    R = R(1:3,1:3); %convert 4x4 matrix to 3x3
end
foo = abs(R);
[~, ixyz] = max(foo); % orientation info: perm of 1:3
if ixyz(2) == ixyz(1), foo(ixyz(2),2) = 0; [~, ixyz(2)] = max(foo(:,2)); end
%if any(ixyz(3) == ixyz(1:2)), ixyz(3) = setdiff(1:3, ixyz(1:2)); end %next line simpler
ixyz(3) = 6 - ixyz(2) - ixyz(1); %make unique: regardless of permutation, [1 2 3] always equal 6
%set sign
for i = 1 : 3
    [~, idx] = max(foo(:,i));
    ixyz(i) = ixyz(i) * sign(R(idx,i));
end
%convert index [-1 2 3] to TrackVis style, e.g. "LAS"
RASLPI = 'XXX';
for i = 1 : 3
    switch ixyz(i)
        case 1 
            RASLPI(i) = 'R';
        case -1 
            RASLPI(i) = 'L';
        case 2 
            RASLPI(i) = 'A';
        case -2 
            RASLPI(i) = 'P';
        case 3 
            RASLPI(i) = 'S';
        case -3 
            RASLPI(i) = 'I';
    end
end
%end affineOrientationSub()