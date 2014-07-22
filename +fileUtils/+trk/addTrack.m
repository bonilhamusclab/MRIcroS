% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat
function addTrack(v,filename, trackSpacing)
%  filename
%MATcro('addTrack','dti.trk', 100)
tic
    hold on
    [header,tracks] = fileUtils.trk.trk_read(filename);
	tracksSmall = tracks(1:trackSpacing:end);
    fib_len=5;
    pointPos = 1;
    for i=1:numel(tracksSmall)
        %stream=tracks(i).matrix;
		nPoints = tracksSmall(i).nPoints;
        if tracksSmall(i).nPoints>fib_len
            %stream = tracksSmall(i).matrix(pointPos:(pointPos+nPoints-1), :); ask about pointPos
			stream = tracksSmall(i).matrix;
            x=stream(:,1);
            y=stream(:,2);
            z=stream(:,3);
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
            plot3(x,y,z,'LineWidth',1,'Color',col)
            hold on
        end
        %pointPos = pointPos+nPoints; ask about pointPos

    end    
    
toc
%end addTrack()
