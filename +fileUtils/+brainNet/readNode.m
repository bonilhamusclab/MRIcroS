function [nsph sphere label]= readNode(filename)
%function [nsph sphere label]= readNode(filename)
%Original code was NI_Load function in BrainNet_LoadFiles.m in project BrainNetViewer
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

fid=fopen(filename);
i=0;
while ~feof(fid)
    curr=fscanf(fid,'%f',5);
    if ~isempty(curr)
        i=i+1;
        textscan(fid,'%s',1);
    end
end
nsph=i;
fclose(fid);
sphere=zeros(nsph,5);
label=cell(nsph,1);
fid=fopen(filename);
i=0;
while ~feof(fid)
    curr=fscanf(fid,'%f',5);
    if ~isempty(curr)
        i=i+1;
        sphere(i,1:5)=curr;
        label{i}=textscan(fid,'%s',1);
    end
end
fclose(fid);
