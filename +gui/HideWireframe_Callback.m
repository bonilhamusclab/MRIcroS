function HideWireframe_Callback(obj, ~)
v=guidata(obj);
nlayer = length(v.surface);
if nlayer > 1
    answer = inputdlg({['Layer (1..' num2str(nlayer) ')']}, 'Enter layer to close wireframe for', 1,{'1'});
    if isempty(answer), disp('close cancelled'); return; end;
    layer = round(str2double(answer));
    layer = utils.boundArray(layer,1,nlayer);
else
    layer = 1;
end; 

commands.hideWireframe(v, layer);