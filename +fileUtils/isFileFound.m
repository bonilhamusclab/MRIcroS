function [filename, isFound] = isFileFound(v, filename)
if exist(filename, 'file')
	isFound = true;
	return;
end
if isfield(v, 'examplesFilePath')
	examplesFilePath = v.examplesFilePath;
else
	examplesFilePath = [fileparts(which('MRIcroS')) filesep '+examples'];
end
tempname = fullfile(examplesFilePath, filename);
isFound = exist(tempname, 'file');
if isFound
	filename = tempname;
end
%end isFileFound()