function is = isMesh(filename)
%function is = isMesh(filename)
if fileUtils.isMat(filename) || fileUtils.isVtk(filename) || fileUtils.isStl(filename) || fileUtils.isPly(filename)  || fileUtils.isObj(filename) || fileUtils.isNv(filename) || fileUtils.isGifti(filename) || fileUtils.isVisa(filename) || fileUtils.isPial(filename)
    is = true;
else
    is = false;
end