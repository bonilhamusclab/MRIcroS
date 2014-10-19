function edges = readEdge(filename)
%function edges = readEdge(filename)
%input: edge extension filename to parse
%BrainNet Node And Edge Connectome Files
%http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0068910
edges = dlmread(filename);
