function parser = stringSafeParse(parser, args, fieldNames, varargin)
%function parser = stringSafeParse(parser, args, fieldNames, varargin)

isArgsNameValue = utils.isArgsNameValue(args, fieldNames);

if ~isArgsNameValue
    args = utils.emptyToDefaults(args, varargin{:});
end

parse(parser, args{:});