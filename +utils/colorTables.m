function [opts, string] = colorTables(clrMap, returnMapNumber)
%Provides list and string of possible color tables
% index : if provided, convert number to name
%Examples 
% [opts, string] = colorTables() %provide a list of colors
% [opts] = colorTables(2); %returns 'autumn'
% [opts] = colorTables('cool'); %returns 'cool'
% [opts] = colorTables('cool',1); %returns 4

opts = {'gray','autumn','bone','cool','copper','hot','hsv','jet','lines','pink','spring','summer','winter' };
if nargin >= 1
    if isnumeric(clrMap) %user can specify number, e.g. 1=gray, 2=autumn, etc
        if isfinite(clrMap)
            clrNum = clrMap;
        else
            clrNum = 1;
        end
    else
        clrNum=find(ismember(opts,lower(deblank(clrMap))));
    end
    if isempty(clrNum) || clrNum < 1 || clrNum > numel(opts)
            clrNum = 1;
    end
    opts = deblank(char(opts(clrNum)));
    if nargin >= 2 && returnMapNumber
       opts = clrNum; 
    end
    return;
end
string = ['[' deblank(char(opts(1)))];
for i = 2: numel(opts)
	nam = deblank(char(opts(i)));
	string=[string, [',' nam ]]; %#ok<AGROW>
end
string = [string, ']'];
%end magnitudesToColors()