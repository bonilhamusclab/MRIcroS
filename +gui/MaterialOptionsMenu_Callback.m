function MaterialOptionsMenu_Callback(obj, ~)
% --- allow user to select appearance of surfaces
v=guidata(obj);
prompt = {'Ambient strength (0..1):','Diffuse strength(0..1):'...
    'Specular strength (0..1)', 'Specular exponent (0..100)','Mode [0=hide edges,1=show edges]:'...
    'Back face reverse lit (1=true)'};
dlg_title = 'Select options for surface material';
a =  v.vprefs.materialKaKdKsn;
def = {num2str(a(1)),num2str(a(2)), num2str(a(3)),num2str(a(4)), num2str( v.vprefs.showEdges),num2str( v.vprefs.backFaceLighting)};
answer = inputdlg(prompt,dlg_title,1,def);
if isempty(answer), disp('options cancelled'); return; end;

bindToZeroOrOne = @(x)(utils.boundArray(str2double(x), 0, 1));
ambience = bindToZeroOrOne(answer(1));
diffuse = bindToZeroOrOne(answer(2));
specularStrength = bindToZeroOrOne(answer(3));
specularExponent = str2double(answer(4));
showEdges = round(str2double(answer(5)));
backFaceLighting = round(str2double(answer(6)));

commands.setMaterial(v, ambience, diffuse, specularStrength, ...
    specularExponent, showEdges, backFaceLighting);

%end MaterialOptionsMenu_Callback()
