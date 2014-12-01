function quickDataViewPopup(filename)

    showData = questdlg('Visualize data as axial slices to assess the range of voxel-wise values?',...
        'Data Overview', 'Yes', 'No', 'Yes');
    if strcmp(showData, 'Yes')
        uiwait(gui.volumeRender.quickDataView(filename));
    end

end