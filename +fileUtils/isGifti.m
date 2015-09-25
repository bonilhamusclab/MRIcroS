function is = isGifti(filename)
%function is = isGifti(filename)
% returns true if the file can be read by SPM's gifti.m
%  this includes GIfTI files as well as FreeSurfer ASCII format files
is = fileUtils.isExt('.gii',filename) || fileUtils.isExt('.srf',filename) || fileUtils.isExt('.asc',filename);