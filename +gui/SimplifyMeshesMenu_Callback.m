function SimplifyMeshesMenu_Callback(obj, ~)
% --- allow user to specify parameters for reducing mesh complexity
v=guidata(obj);
reduce = 0.25;

numMeshes = 0;
if(isfield(v, 'surface'))
    numMeshes = length(v.surface);
end
moreThanOneMesh = numMeshes > 1;

resolutionMsg = 'Reduce Path, e.g. 0.5 means half resolution (0..1):';

prompt = {resolutionMsg};
dlg_title = 'Select options for simplifying image';
def = {num2str(reduce)};

if(moreThanOneMesh)
    meshesMsg = sprintf(...
        'Specify Mesh Index to simplify (0 for all, max mesh is %d):', numMeshes);
    prompt = {resolutionMsg, meshesMsg};
    def = {num2str(reduce), num2str(0)};
end

answer = inputdlg(prompt,dlg_title,1,def);

if isempty(answer), disp('simplify cancelled'); return; end;

reduce = str2double(answer(1));

meshIndx = 0;
if(moreThanOneMesh)
    meshIndx = str2double(answer(2));
end

commands.simplifyMeshes(v,reduce, meshIndx)
%end SimplifyMeshesMenu_Callback()
