% --- let user select layer, then set RGBA for that layer 
function OverlayOptionsMenu_Callback(obj, eventdata)
v=guidata(obj);
nlayer = length(v.surface);
if nlayer > 1
    answer = inputdlg({['Layer [1= background] (1..' num2str(nlayer) ')']}, 'Enter layer to modify', 1,{'1'});
    if isempty(answer), disp('options cancelled'); return; end;
    layer = round(str2double(answer));
    layer = boundArray(layer,1,nlayer);
else
    layer = 1;
end; 
v.vprefs.colors(layer,1:3) = uisetcolor( v.vprefs.colors(layer,1:3),'select color');
answer = inputdlg({'Alpha (0[transparent]..1[opaque])'},'Set opacity',1,{num2str( v.vprefs.colors(layer,4))} );
if isempty(answer), disp('options cancelled'); return; end;
v.vprefs.colors(layer,4) = str2double(answer(1));
v.vprefs.colors(layer,:) = boundArray( v.vprefs.colors(layer,:), 0,1);
guidata(v.hMainFigure,v);%store settings
redrawSurface(v); %display new settings
%end OverlayOptionsMenu_Callback()
