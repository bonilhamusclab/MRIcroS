function saveMesh(v, filename)
% --- save mesh(es) as PLY, VTK or (if SPM is installed) GIfTI format file
% requires SPM
[path,file,ext] = fileparts(filename);
for i=1:length(v.surface)
    if (i > 1) 
        filename = fullfile(path, [file num2str(i) ext]);
    end;
    if fileUtils.isGifti(filename)
        if (exist('gifti.m', 'file') == 2)
            g = gifti(v.surface(i));
            save(g,filename,'GZipBase64Binary');
        else
            fprintf('Error: Unable to save GIfTI files - make sure SPM is installed');
        end;
    elseif fileUtils.isMat(filename)
        fileUtils.mat.writeMat(v.surface(i).vertices,v.surface(i).vertexColors,...
            v.surface(i).faces,filename, v.surface(i).colorMap, v.surface(i).colorMin);
    elseif fileUtils.isVtk(filename)
        fileUtils.vtk.writeVtk(v.surface(i).vertices,v.surface(i).faces,filename);
    else
        if ~isempty(v.surface(i).vertexColors) %PLY only supports RGB, not scalar
            v.surface(i).vertexColors = utils.magnitudesToColors(v.surface(i).vertexColors, v.surface(i).colorMap);
        end
        fileUtils.ply.writePly(v.surface(i).vertices,v.surface(i).vertexColors,v.surface(i).faces,filename);
    end;
end;
%end saveMesh()

