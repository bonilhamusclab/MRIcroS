function indx = fieldIndex(v, field)
% function indx = fieldIndex(v, field)
% inputs
%	v: the guidata associated with the field
%	field: property of v that specifies an array of some sort
% outputs
%	indx: the indx of the next item that can be added to the field
% Why use? To conviniently find a safe index to add with the field
	hasField = isfield(v,field);
	indx = 1;
	if(hasField), indx = indx + length(getfield(v, field)); end
