function f = quickDataView(fileName)

    f = figure;
    a = axes('Parent', f);
    [hdr, vols] = fileUtils.nifti.readNifti(fileName);
    zPt = round(hdr.dim(3)/2);
    
    function showIm(zPt) 
        imagesc(vols(:,:,zPt), 'Parent', a, [min(vols(:)) max(vols(:))]);
        colorbar;
    end

    showIm(zPt);
    
    uicontrol('Style', 'Slider', 'Parent', f,...
        'Min', 1, 'Max', hdr.dim(3), 'Value', zPt, ...
        'Callback', @(s, ~)showIm(round(s.Value)));
end