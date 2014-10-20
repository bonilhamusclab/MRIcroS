function isNameValue = isArgsNameValue(args, fieldNames)
%function isNameValue = isArgsNameValues(args, fieldNames)

numArgs = length(args);

isNameValue = 0;
for i = 1:numArgs
    isNameValue = sum(strcmp(args(i), fieldNames));
    if isNameValue
        break;
    end
end