function figure(varargin)
Q = lib.ecma.struct(...
	'type',		'pdf',...
	varargin{:} ...
);

fSave = @(path,type) saveas(Q.figure,[path '.' type]);


switch class(Q.type)
	case 'char'
	fSave(Q.filepath, Q.type);
	
	case 'cell'
	cellfun(@(type) fSave(Q.filepath,type),Q.type);
	
	otherwise
	error('invalid file type');
end

