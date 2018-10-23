function varargout = polyfit(varargin)
Q = lib.ecma.struct(...
	'n',		1,...
	'XScale',	'linear',...
	'YScale',	'linear',...
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
	Y = Q.y;
	
	case 'log'
	Y = log(Q.y);
end

[varargout{1:nargout}] = polyfit(X,Y,Q.n);

