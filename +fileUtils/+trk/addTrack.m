% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat
function addTrack(v,filename, trackSpacing, fiber_len)
%  filename
%MATcro('addTrack','dti.trk', 100)
	if(nargin < 3) trackSpacing = 100; end
	if(nargin < 4) fiber_len = 5; end
tic
    hold on
    [header,tracks] = fileUtils.trk.trk_read(filename, trackSpacing);
	voxel_size = header.voxel_size;
    pointPos = 1;
	renderedFiberIndex = 0;
	numTracks = numel(tracks);
	renderedFibers = zeros(numTracks, 1);
    for i=1:numTracks
		nPoints = tracks(i).nPoints;
        if nPoints>fiber_len
			stream = tracks(i).matrix;
			%normalize voxels to mm
			stream(:,1) = stream(:,1)./voxel_size(1);
			stream(:,2) = stream(:,2)./voxel_size(2);
			stream(:,3) = stream(:,3)./voxel_size(3);
			%change to ras
			stream = [stream ones(nPoints, 1)] * header.vox_to_ras';
			%change to las
			stream(:,1) = -1 * stream(:,1);
			x = stream(:,1);
			y = stream(:,2);
			z = stream(:,3);
            x_first=x(1);
            x_last=x(end);
            y_first=y(1);
            y_last=y(end);
            z_first=z(1);
            z_last=z(end);
            % x displacement
            xdisp=abs(x_first-x_last);
            % y displacement
            ydisp=abs(y_first-y_last);
            % z displacement
            zdisp=abs(z_first-z_last);
            % relative x displacement
            Rxdisp=xdisp/(xdisp+ydisp+zdisp);
            Rydisp=ydisp/(xdisp+ydisp+zdisp);
            Rzdisp=zdisp/(xdisp+ydisp+zdisp);
            col=[Rxdisp,Rydisp,Rzdisp];
            % plot
			renderedFiberIndex = renderedFiberIndex + 1;
            renderedFibers(renderedFiberIndex) = plot3(x,y,z,'LineWidth',1,'Color',col);
            hold on
        end
        %pointPos = pointPos+nPoints; ask about pointPos

    end    
	hasTrack = isfield(v,'tracks');
	tracksIndex = 1;
	if(hasTrack) tracksIndex = tracksIndex + length(v.tracks); end
	v.tracks(tracksIndex).fibers = renderedFibers(1:renderedFiberIndex);
	guidata(v.hMainFigure, v);
	drawing.removeDemoObjects(v);
    
toc
%end addTrack()
