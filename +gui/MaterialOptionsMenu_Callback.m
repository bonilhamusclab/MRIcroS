function MaterialOptionsMenu_Callback(obj, eventdata)
% --- allow user to select appearance of surfaces
v=guidata(obj);
prompt = {'Ambient strength (0..1):','Diffuse strength(0..1):'...
    'Specular strength (0..1)', 'Specular exponent (0..100)','Mode [0=hide edges,1=show edges]:'...
    'Back face reverse lit (1=true)'};
dlg_title = 'Select options for surface material';
a =  v.vprefs.materialKaKdKsn;
def = {num2str(a(1)),num2str(a(2)), num2str(a(3)),num2str(a(4)), num2str( v.vprefs.bgMode),num2str( v.vprefs.backFaceLighting)};
answer = inputdlg(prompt,dlg_title,1,def);
if isempty(answer), disp('options cancelled'); return; end;
 v.vprefs.materialKaKdKsn(1) = str2double(answer(1));
 v.vprefs.materialKaKdKsn(2) = str2double(answer(2));
 v.vprefs.materialKaKdKsn(3) = str2double(answer(3));
 v.vprefs.materialKaKdKsn(1:3) = boundArray( v.vprefs.materialKaKdKsn(1:3),0,1);
 v.vprefs.materialKaKdKsn(4) = str2double(answer(4));
 v.vprefs.bgMode = round(str2double(answer(5)));
 v.vprefs.backFaceLighting = round(str2double(answer(6)));
 guidata(v.hMainFigure,v);%store settings
drawing.redrawSurface(v);
%end MaterialOptionsMenu_Callback()
