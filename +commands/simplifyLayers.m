% ---  reduce mesh complexity
function simplifyLayers(v, varargin)
% inputs: reductionRatio
%MATcro('simplifyLayers', 0.2); %reduce mesh to 20% complexity
if (length(varargin) < 1), return; end;
reduce = cell2mat(varargin(1));
doSimplifyMesh(v,reduce)
%end simplifyLayers()
