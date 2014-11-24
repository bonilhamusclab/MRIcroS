function [header data] = readTrack(fullPath)
%read TrackVis .trk format data
% fillPath: filename of track to read.
%for format details http://www.trackvis.org/docs/?subsect=fileformat

fid = fopen(fullPath);
header = getHeader(fid);
if header.hdr_size~=1000
    fclose(fid);
    fid    = fopen(filePath, 'r', 'b'); % Big endian for old PPCs
    header = getHeader(fid);
	if(header.hdr_size ~= 1000)
		error('Header length is not 1000, file may be corrupted');
	end
end
seekFirstDataPoint(fid);
dataAsFloat = fread(fid, inf, 'float32');
seekFirstDataPoint(fid);
pointCountsPerTrack = fread(fid, inf, 'int32');
data = mergeDataPointsAndCounts(dataAsFloat, pointCountsPerTrack, header);
fclose(fid);
%end readTrack()

function seekFirstDataPoint(fid)
	fseek(fid, 1000, -1);
%end seekFirstDataPoint()

function data = mergeDataPointsAndCounts(dataAsFloat, pointCountsPerTrack, header)
	countIndex = 1;
	dataPointCount = length(dataAsFloat);
	data = dataAsFloat;
	pointDim = 3 + header.n_scalars;%3 (xyz) + num scalars
	while countIndex < dataPointCount
		pointsInBatch = pointCountsPerTrack(countIndex);
		data(countIndex) = pointsInBatch;
		countIndex = countIndex + pointsInBatch * pointDim + header.n_properties+ 1; 
	end
%end mergeDataPointsAndCounts()

function header = getHeader(fid)
	header.id_string                 = fread(fid, 6, '*char')';
	header.dim                       = fread(fid, 3, 'short')';
	header.voxel_size                = fread(fid, 3, 'float')';
	header.origin                    = fread(fid, 3, 'float')';
	header.n_scalars                 = fread(fid, 1, 'short')';
	header.scalar_name               = fread(fid, [20,10], '*char')';
	header.n_properties              = fread(fid, 1, 'short')';
	header.property_name             = fread(fid, [20,10], '*char')';
	header.vox_to_ras                = fread(fid, [4,4], 'float')';
	header.reserved                  = fread(fid, 444, '*char');
	header.voxel_order               = fread(fid, 4, '*char')';
	header.pad2                      = fread(fid, 4, '*char')';
	header.image_orientation_patient = fread(fid, 6, 'float')';
	header.pad1                      = fread(fid, 2, '*char')';
	header.invert_x                  = fread(fid, 1, 'uchar');
	header.invert_y                  = fread(fid, 1, 'uchar');
	header.invert_z                  = fread(fid, 1, 'uchar');
	header.swap_xy                   = fread(fid, 1, 'uchar');
	header.swap_yz                   = fread(fid, 1, 'uchar');
	header.swap_zx                   = fread(fid, 1, 'uchar');
	header.n_count                   = fread(fid, 1, 'int')';
	header.version                   = fread(fid, 1, 'int')';
	header.hdr_size                  = fread(fid, 1, 'int')';
%end getHeader()