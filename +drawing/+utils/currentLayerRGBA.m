function [clr, alph] = currentLayerRGBA(layerIndex, colors)
%function [clr, alph] = currentLayerRGBA(layerIndex, colors)
    clr = colors ( (mod(layerIndex-1,length( colors))+1) ,1:3);
    alph = colors (mod(layerIndex,length( colors)),4);