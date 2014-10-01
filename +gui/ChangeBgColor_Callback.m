function ChangeBgColor_Callback(obj, ~)
% --- allow user to change bg color 
v=guidata(obj);

newBgColor = uisetcolor;

if(length(newBgColor) > 1)
	commands.changeBgColor(v, newBgColor);
end
