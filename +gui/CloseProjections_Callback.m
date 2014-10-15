function CloseProjections_Callback(obj, ~)
% --- add a new voxel image or mesh as a layer with default options
v=guidata(obj);

[layer, cancelled] = selectLayerSub(v);
if(cancelled), return; end;

commands.closeProjections(v, layer);

end

function [layer, cancelled] = selectLayerSub(v)
    cancelled = 0;
    nlayer = length(v.surface);
    if nlayer > 1
        layersWithProjections = [];
        for i = 1:nlayer
            if v.surface(i).colorVertices
                layersWithProjections = [layersWithProjections i];
            end
        end
        firstLayerWithProjection = layersWithProjections(1);
        if isempty(layersWithProjections)
            cancelled = 1;
            disp('close projections cancelled, no layer has projections'); 
            return;
        elseif length(layersWithProjections) == 1
            layer = firstLayerWithProjection;
        else
            answer = inputdlg({['Layers (' num2str(layersWithProjections) ') have projections']}, 'Enter layer to close projections on', 1,{num2str(firstLayerWithProjection)});
            if isempty(answer), disp('close projections cancelled'); return; end;
            layer = round(str2double(answer));
            layer = utils.boundArray(layer,1,nlayer);
        end
    else
        layer = 1;
    end
end