function [clr, alph] = defaultLayerColorAndAlpha(layerIndex, colors)
    clr = colors ( (mod(layerIndex-1,length( colors))+1) ,1:3);
    alph = colors (mod(layerIndex,length( colors)),4);