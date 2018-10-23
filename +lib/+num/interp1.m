function varargout = interp1(varargin)
Q = lib.ecma.struct(...
	'method',			'spline',...
	'XScale',			'linear',...
	'YScale',			'linear',...
	'extrapolation',	{},...
	varargin{:} ...
);

switch Q.XScale
	case 'linear'
	X	= Q.x;
	Xq	= Q.xq;
	
	case 'log'
	X	= log(Q.x);
	Xq	= log(Q.xq);
end

switch Q.YScale
	case 'linear'
	[varargout{1:nargout}] = interp1(X,Q.y,Xq,Q.method,Q.extrapolation{:});
	
	case 'log'
	Y = log(Q.y);
	
	% filter only valid values
	kk = ~isinf(X) & ~isnan(X) & ~isinf(Y) & ~isnan(Y);
	X = X(kk);
	Y = Y(kk);
	
	% interpolate values
	[varargout{1:nargout}] = exp(interp1(X,Y,Xq,Q.method,Q.extrapolation{:}));
end



