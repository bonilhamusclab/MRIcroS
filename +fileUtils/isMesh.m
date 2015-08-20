function is = isMesh(filename)
%function is = isMesh(filename)
if fileUtils.isMat(filename) || fileUtils.isVtk(filename) || fileUtils.isStl(filename) || fileUtils.isPly(filename) || fileUtils.isPial(filename) || fileUtils.isNv(filename) || fileUtils.isGifti(filename) 
    is = true;
else
    is = false;
end