function y = round(x,varargin)
Q = lib.ecma.struct(...
	'base',		1,...
	'prec',		0,...
	'scale',	'linear',...
	varargin{:} ...
);

switch Q.scale
	case 'linear'
	y = Q.base*round(x./Q.base,Q.prec);
	
	case 'log'
	y = Q.base.^floor(log(x)./log(Q.base));
end