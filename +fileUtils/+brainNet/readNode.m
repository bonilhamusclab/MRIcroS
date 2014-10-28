function [nsph, spheres, labels]= readNode(filename)
%function [nsph, spheres, labels]= readNode(filename)
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
%
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
%modified to allow comments in node files 
% comments are lines that start with the # symbol
    fid = fopen(filename);
    %data = textscan(fid,'%f %f %f %f %f %s','Delimiter','\t','CommentStyle','#');
    data = textscan(fid,'%f %f %f %f %f %s','CommentStyle','#');
    fclose(fid);
    spheres = [cell2mat(data(1)) cell2mat(data(2)) cell2mat(data(3)) cell2mat(data(4)) cell2mat(data(5))];
    labels = data(6);
    for i = 1: size(spheres,1)
        lineOp(i, spheres(i,:), labels{1}(i));
    end
end
%scanNodeFileSub

function scanNodeFileSubOld(filename, lineOp)
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
