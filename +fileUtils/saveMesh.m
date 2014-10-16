function saveMesh(v, filename)
% --- save mesh(es) as PLY, VTK or (if SPM is installed) GIfTI format file
% requires SPM
[path,file,ext] = fileparts(filename);
for i=1:length(v.surface)
    if (i > 1) 
        filename = fullfile(path, [file num2str(i) ext]);
    end;
    if (length(ext) == 4) && strcmpi(ext,'.gii')
        if (exist('gifti.m', 'file') == 2)
            g = gifti(v.surface(i));
            save(g,filename,'GZipBase64Binary');
        else
            fprintf('Error: Unable to save GIfTI files - make sure SPM is installed');
        end;
    elseif (length(ext) == 5) && strcmpi(ext,'.trib')
        fileUtils.trib.writeTrib(v.surface(i).vertices,v.surface(i).vertexColors,v.surface(i).faces,filename);
    elseif (length(ext) == 4) && strcmpi(ext,'.vtk')
        fileUtils.vtk.writeVtk(v.surface(i).vertices,v.surface(i).faces,filename);
    else
        fileUtils.ply.writePly(v.surface(i).vertices,v.surface(i).vertexColors,v.surface(i).faces,filename);
    end;
end;
%end saveMesh()
