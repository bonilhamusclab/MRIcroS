function [header,tracks] = trk_read(filePath, trackSpacing)
%TRK_READ - Load TrackVis .trk files
%TrackVis displays and saves .trk files in LPS orientation. After import, this
%function attempts to reorient the fibers to match the orientation of the
%original volume data.
%
% Syntax: [header,tracks] = trk_read(filePath)
%
% Inputs:
%    filePath - Full path to .trk file [char]
%    trackSpacing - 1/trackSpacing tracks will be saved. Greatly speeds loading but loses information; ALSO, HEADER INFORMATION NOT CHANGED DESPITE BODY CHANGE (SUCH AS dim AND n_count)
%
% Outputs:
%    header - Header information from .trk file [struc]
%    tracks - Track data structure array [1 x nTracks]
%      nPoints - # of points in each streamline
%      matrix  - XYZ coordinates (in mm) and associated scalars [nPoints x 3+nScalars]
%      props   - Properties of the whole tract (ex: length)
%
% Example:
%    exDir           = '/path/to/along-tract-stats/example';
%    subDir          = fullfile(exDir, 'subject1');
%    trkPath         = fullfile(subDir, 'CST_L.trk');
%    [header tracks] = trk_read(trkPath);
%
% Other m-files required: none
% Subfunctions: get_header
% MAT-files required: none
%
% See also: http://www.trackvis.org/docs/?subsect=fileformat
%           http://github.com/johncolby/along-tract-stats/wiki/orientation

% Author: John Colby (johncolby@ucla.edu)
% UCLA Developmental Cognitive Neuroimaging Group (Sowell Lab)
% Mar 2010

if(nargin == 1) trackSpacing = 1; end

% Parse in header
fid    = fopen(filePath, 'r');
header = get_header(fid);

% Check for byte order
if header.hdr_size~=1000
    fclose(fid);
    fid    = fopen(filePath, 'r', 'b'); % Big endian for old PPCs
    header = get_header(fid);
end

if header.hdr_size~=1000, error('Header length is wrong'), end

% Parse in body
if header.n_count > 0
	max_n_trks = header.n_count;
else
	% Unknown number of tracks; we'll just have to read until we run out.
	max_n_trks = inf;
end

% It's impossible to preallocate the "tracks" variable because we don't
% know the number of points on each curve ahead of time; we find out by
% reading the file.  The line below suppresses preallocation warnings.
%#ok<*AGROW>

iTrk = 1;
iTrkSave = 1;
start = tic;
while iTrk <= max_n_trks
	if feof(fid)
		break;
	end
	if(trackSpacing == 1 || mod(iTrk, trackSpacing) == 0)
		track = readTrack(fid, header);
		tracks(iTrkSave).nPoints = track.nPoints;
		tracks(iTrkSave).matrix = track.matrix;
		
		if header.n_properties
			tracks(iTrkSave).props = track.props;
		end
		iTrkSave = iTrkSave + 1;
	else
		skipTrack(fid, header);
	end
	iTrk = iTrk + 1;
end
toc(start)

if header.n_count == 0
	header.n_count = length(tracks);
end

fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function track = readTrack(fid, header)
	track = {};
	pts = fread(fid, 1, 'int');
	track.nPoints = pts;
	matrix = fread(fid, [3 + header.n_scalars, pts], '*float')';
	track.matrix = matrix;
	if header.n_properties
		track.props = fread(fid, header.n_properties, '*float');
	end

function skipTrack(fid, header)
	pts = fread(fid, 1, 'int');
	floatsOrIntsToSkip = (3 + header.n_scalars) * pts + header.n_properties; 
	bytesToSkip = floatsOrIntsToSkip * 4;
	fseek(fid, bytesToSkip, 'cof');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function header = get_header(fid)

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
