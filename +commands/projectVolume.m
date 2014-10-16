function projectVolume(v, surfaceIndex, volumeFile, varargin)
%function projectVolume(v, surfaceIndex, volumeFile, varargin)
%a wrapper function for utils.projectVolume
%faces and vertices obtained from surface index, than all inputs passed to
%utils.volumeIntensitiesToVertexColors
%help utils.volumeIntensitiesToVertexColors

surface = v.surface(surfaceIndex);
faces = surface.faces;
vertices = surface.vertices;

vertexColors = utils.volumeIntensitiesToVertexColors(vertices, faces, volumeFile, varargin);

v.surface(surfaceIndex).vertexColors = vertexColors;

drawing.redrawSurface(v);