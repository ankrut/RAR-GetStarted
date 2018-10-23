function varargout = polyval(varargin)
Q = lib.ecma.struct(...
	'XScale',	'linear',...
	'YScale',	'linear',...
	'polyval',	{},...
	varargin{:} ...
);

switch Q.XScale
	case 'linear'
	X = Q.x;
	
	case 'log'
	X = log(Q.x);
end

switch Q.YScale
	case 'linear'
	[varargout{1:nargout}]  = polyval(Q.coeffs,X,Q.polyval{:});
	
	case 'log'
	[varargout{1:nargout}]  = exp(polyval(Q.coeffs,X,Q.polyval{:}));
end

