% --- Load trackvis fibers http://www.trackvis.org/docs/?subsect=fileformat
function addTrack(v,filename)
%  filename
%MATcro('addTrack','dti.trk');
tic

    hold on
    [header,tracks] = trk_read2(filename,true);
    fib_len=5;
    pointPos = 1;
    for i=1:numel(tracks.nPoints)
        %stream=tracks(i).matrix;
        if tracks.nPoints(i)>fib_len
            stream = tracks.matrix(pointPos:(pointPos+tracks.nPoints(i)-1), :);
            x=stream(:,1);
            y=stream(:,2);
            z=stream(:,3);
            x_first=stream(1,1);
            x_last=stream(end,1);
            y_first=stream(1,2);
            y_last=stream(end,2);
            z_first=stream(1,3);
            z_last=stream(end,3);
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
        pointPos = pointPos+tracks.nPoints(i);
    end    
    
toc
%end addTrack()
