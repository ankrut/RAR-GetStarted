function varargout = marker(varargin)
Q = lib.ecma.struct(...
	'plot', {'LineStyle', 'none', 'Marker', '.'},...
	varargin{:}...
);

X = parseValue(Q.x,Q);
Y = parseValue(Q.y,Q);

[varargout{1:nargout}] = plot(X,Y,Q.plot{:});

function X = parseValue(MAP, Q)
switch class(MAP)
	case 'double'
	X = MAP;
	
	case 'function_handle'
	X = QMAP(Q.data);
	
	case {'lib.profile.mapping', 'lib.profile.axis'}
	if isfield(Q,'anchor')
		X = Q.anchor.map('data', Q.data, 'y', MAP);
	else
		X = MAP.map(Q.data);
	end
	
	otherwise
	error('invalid value');
end