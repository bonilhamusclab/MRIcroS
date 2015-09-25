function is = isMesh(filename)
%function is = isMesh(filename)
if fileUtils.isMat(filename) || fileUtils.isVtk(filename) || fileUtils.isStl(filename) || fileUtils.isPly(filename)  || fileUtils.isNv(filename) || fileUtils.isGifti(filename) || fileUtils.isPial(filename)
    is = true;
else
    is = false;
end