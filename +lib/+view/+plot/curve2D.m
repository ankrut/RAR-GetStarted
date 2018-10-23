function h=curve2D(varargin)
Q = lib.ecma.struct(...
	'plot',		{},...
	varargin{:}...
);

% plot curve
h = plot(...
	getData(Q.data,Q.x),...
	getData(Q.data,Q.y),...
	Q.plot{:} ...
);

function X = getData(profile,ax)
switch(class(ax))
	case 'function_handle'
		X = ax(profile);
		
	case {'lib.profile.mapping', 'lib.profile.axis'}
		X = ax.map('data', profile);
		
	case 'double'
		X = ax;
end