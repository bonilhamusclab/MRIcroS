function simplifyLayers(v, varargin)
%function simplifyLayers(v, varargin)
% ---  reduce mesh complexity
%MATcro('simplifyLayers', 0.2); %reduce mesh to 20% complexity
% inputs: reductionRatio
if (length(varargin) < 1), return; end;
reduce = cell2mat(varargin(1));
doSimplifyMesh(v,reduce)
%end simplifyLayers()
