function is = isVisa(filename)
%function is = isStl(filename)
is = fileUtils.isExt('.mesh',filename) || fileUtils.isExt('.tri',filename);