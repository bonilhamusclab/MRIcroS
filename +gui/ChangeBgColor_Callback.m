function ChangeBgColor_Callback(obj, ~)
% --- allow user to change bg color 
v=guidata(obj);

newBgColor = uisetcolor;

if(newBgColor)
	commands.changeBgColor(v, newBgColor);
end
