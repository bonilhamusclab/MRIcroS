function brain_handle = plotFacesAndVertices(faces, vertices)
%function brain_handle = plotFacesAndVertices(faces, vertices)
%inputs:
%	faces: matrix of faces - each row is a face and xyz cols
%	vertices: matrix of vertices - each row is a vertix and xyz cols


brain_handle=patch('faces', faces, 'vertices', vertices);
set(gca,'DataAspectRatio',[1 1 1])
        axis vis3d;
        rotate3d on;
        grid off
        axis off
        grid MINOR
        alpha(0.1)
        Objects = findobj(gcf);
        set(gcf,'Renderer','OpenGL')

        %shading interp
        set(brain_handle,'EdgeColor','none')
        set(brain_handle,'FaceAlpha',0.1)
        set(brain_handle,'FaceColor',[0.7 0.7 0.9])

        view(270, 0);

        camlight('right')
        % set camera
        camera_obj=findobj(gca,'Type','light');
        camera_handle=camera_obj(1);
        set(camera_handle,'Color',[0.7 0.7 0.7])
