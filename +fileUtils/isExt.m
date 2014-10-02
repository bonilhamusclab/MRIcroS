function is = isExt(ext, filename)
    [~, ~, fileExt] = fileparts(filename);
    is = strcmpi(ext, fileExt);