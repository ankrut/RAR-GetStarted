function h=curve2D(varargin)
Q = lib.module.struct(...
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
		
	case {'lib.module.ProfileMapping', 'lib.module.ProfileAxis'}
		X = ax.map(profile);
		
	case 'double'
		X = ax;
end