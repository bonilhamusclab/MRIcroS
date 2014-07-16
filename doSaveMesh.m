% --- save mesh(es) as PLY, VTK or (if SPM is installed) GIfTI format file
function doSaveMesh(v, filename)
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
    elseif (length(ext) == 4) && strcmpi(ext,'.vtk')
        writeVtkSub(v.surface(i).vertices,v.surface(i).faces,filename);
    else
        writePlySub(v.surface(i).vertices,v.surface(i).faces,filename);
    end;
end;
%end doSaveMesh()
