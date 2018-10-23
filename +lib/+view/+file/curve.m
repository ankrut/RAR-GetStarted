function curve(varargin)
Q = parseArguments(varargin{:});

% destructure
AXES	= lib.ecma.array(struct2array(Q.axes));

% extract data
label	= fieldnames(Q.axes);
symbol	= AXES.map(@(t) t.mapmodel.var).data;
unit	= AXES.map(@(t) regexprep(t.scalemodel.unit,'\\mathrm\{([\w\/]+)\}','$1')).data;
data	= AXES.map(@(t) t.map(Q.data)).data;

% define print format
formatSpecHeader = ['#%12s' repmat(' %12s',[1, numel(label)-1]) '\r\n'];
formatSpecData	 = [repmat(' %E',[1, numel(label)]) '\r\n'];

% open file
fh = fopen(Q.filepath,'w');

% write header
if lib.bool.logical(Q.label)
	fprintf(fh,formatSpecHeader,label{:});
end

if lib.bool.logical(Q.symbol)
	fprintf(fh,formatSpecHeader,symbol{:});
end

if lib.bool.logical(Q.unit)
	fprintf(fh,formatSpecHeader,unit{:});
end

% write data
fprintf(fh,formatSpecData,[data{:}]);

% close file
fclose(fh);

function Q = parseArguments(varargin)
Q = lib.ecma.struct(...
	'label',	'on',...
	'symbol',	'on',...
	'unit',		'on',...
	varargin{:} ...
);

if isfield(Q,'header')
	Q = switchHeader(Q);
end

function Q = switchHeader(Q)
switch Q.header
	case 'on'
	Q.label		= 'on';
	Q.symbol	= 'on';
	Q.unit		= 'on';
	
	case 'off'
	Q.label		= 'off';
	Q.symbol	= 'off';
	Q.unit		= 'off';
	
	otherwise
	error('Unknown [header] value');
end
		
