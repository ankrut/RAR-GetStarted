function varargout = interp1(varargin)
Q = lib.ecma.struct(...
	'scale',	'linear',...
	'interp1',	{},...
	'plot',		{},...
	varargin{:}...
);

% get data
X = getData(Q.data,Q.x);
Y = getData(Q.data,Q.y);

% interpolate data
switch Q.scale
	case 'linear'
	iY = interp1(X,Y,Q.grid,Q.interp1{:});
	
	case 'log'
	iY = exp(interp1(log(X),log(Y),log(Q.grid),Q.interp1{:}));
end
		

% plot curve
[varargout{1:nargout}] = plot(...
	Q.grid,...
	iY,...
	Q.plot{:} ...
);

function X = getData(profile,ax)
switch(class(ax))
	case 'function_handle'
		X = ax(profile);
		
	case {'lib.profile.mapping', 'lib.profile.axis'}
		X = ax.map(profile);
		
	case 'double'
		X = ax;
end