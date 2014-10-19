function RotateToggle_Callback(promptForValues, obj, ~)
	v = guidata(obj);
	
    currLabel = get(v.hRotateToggleMenu, 'label');
    
    stopLabel = 'Stop';
	isStopLabel = strcmp(currLabel, stopLabel);
    
    rotateLabel = 'Rotate';
    rotateWithOptionsLabel = 'Rotate With Options';
    
	if ~isStopLabel
		set(v.hRotateToggleMenu, 'label', stopLabel);
        set(v.hRotateToggleWithOptionsMenu, 'label', stopLabel);
        if(promptForValues)
            [horAngle, verAngle] = promptForValuesSub();
            startRotatingSub(v, horAngle, verAngle);
        else
            startRotatingSub(v);
        end
	else
		set(v.hRotateToggleMenu, 'label', rotateLabel);
        set(v.hRotateToggleWithOptionsMenu, 'label', rotateWithOptionsLabel);
		stopRotatingSub(v);
    end
    
    
end

function startRotatingSub(v, horAngle, verAngle)
%default values: 
%	horAngle = 5
%	verAngle = 0

	if (nargin < 2)
		horAngle = 5;
        if (nargin < 3)
			verAngle = 0;
        end
    end

	h = gui.getGuiHandle(); 

	v.rotating = 1;
	guidata(v.hMainFigure, v);

	while v.rotating
        v = guidata(h);
		if ~v.rotating
			break;
		end
		camorbit(horAngle, verAngle);
        drawnow
	end
end



function stopRotatingSub(v)
	v.rotating = 0;
	guidata(v.hMainFigure, v);
end

function [horAngle, verAngle] = promptForValuesSub()
    prompt = {'Horizontal Angle (degrees):','Vertical Angle (degrees)'};
    opts = inputdlg(prompt, 'Rotate Options', 1, {num2str(5), num2str(0)});
    if isempty(opts), disp('rotate cancelled'); return; end;
    horAngle = str2double(opts(1));
    verAngle = str2double(opts(2));
end