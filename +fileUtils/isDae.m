function is = isDae(filename)
%function is = isDae(filename)
% returns true if file extension is .dae (SPM's gifti can export to Collada format)
is = fileUtils.isExt('.dae',filename);