function [nsph, spheres, labels]= readNode(filename)
%function [nsph, spheres, labels]= readNode(filename)
%Original code modified from NI_Load function in BrainNet_LoadFiles.m 
%in project BrainNetViewer
%BrainNet Viewer, a graph-based brain network mapping tool, by Mingrui Xia
%Function to load files for graph drawing
%-----------------------------------------------------------
%   Copyright(c) 2013
%   State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University
%   Written by Mingrui Xia
%   Mail to Author:  <a href="mingruixia@gmail.com">Mingrui Xia</a>
%   Version 1.43;
%   Date 20110531;
%   Last edited 20131227
%-----------------------------------------------------------
%

    
    scanCurrentNodeFile = utils.curry(@scanNodeFileSub, filename);
    
    nsph = 0;
    function updateNsph(i, ~, ~)
        if(i > nsph)
            nsph = i;
        end
    end

    scanCurrentNodeFile(@updateNsph);
    
    
    spheres=zeros(nsph,5);
    labels=cell(nsph,1);
    function updateSpheresAndLabels(i, sphere, label)
        spheres(i,1:5)=sphere;
        labels{i} = label;
    end

    scanCurrentNodeFile(@updateSpheresAndLabels);
    
end

function scanNodeFileSub(filename, lineOp)
    fid = fopen(filename);
    i=0;
    while ~feof(fid)
        sphere=fscanf(fid,'%f',5);
        if ~isempty(sphere)
            i=i+1;
            labelCell = textscan(fid,'%s',1);
            label = labelCell{1};
            lineOp(i, sphere, label);
        end
    end
    fclose(fid);
end