function [filename, isFound] = getExampleFile(obj, filename)
    
    v = guidata(obj);
    
    if isfield(v, 'examplesFilePath')
        examplesFilePath = v.examplesFilePath;
    else
        examplesFilePath = [fileparts(which('MRIcroS')) filesep '+examples'];
    end
    
    filename = fullfile(examplesFilePath, filename);
    
    isFound = exist(filename, 'file');
    
end