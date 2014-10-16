function [nodeColorMap, isCancelled] = promptColorMap()
    colorMapOpts = {'jet','hsv','hot','cool','spring','summer',...
        'autumn', 'winter', 'gray','bone','copper','pink','lines'};
    nodeColorMapIndex = listdlg('SelectionMode','Single',...
        'ListString', colorMapOpts);
    isCancelled = isempty(nodeColorMapIndex);
    if(isCancelled), 
        nodeColorMap = 'jet';
    else
        nodeColorMap = colorMapOpts{nodeColorMapIndex};
    end

%end promptColorMap
