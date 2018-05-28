function y = roundlog(x,varargin)
Q = lib.module.struct(...
	'prec', 0,...
	varargin{:} ...
);

d = floor(log10(x));
m = 10^d;

if d >= 0
	y = m*round(x./m,d+Q.prec);
else
	y = m*round(x./m,Q.prec);
end