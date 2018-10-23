% load packages
MAP = lib.ecma.require(@lib.model.cRAR.map);

EXPORT.radius = @(R) lib.profile.anchor(...
	'x',		@(obj) MAP.radius.fmap(obj),...
	'xq',		@(obj,X) R,...
	'xscale',	'log' ...
);

EXPORT.mass = @(M) lib.profile.anchor(...
	'x',		@(obj) MAP.mass.fmap(obj),...
	'xq',		@(obj,X) M,...
	'xscale',	'log' ...
);

EXPORT.density = @(RHO) lib.profile.anchor(...
	'x',		@(obj) MAP.density.fmap(obj),...
	'xq',		@(obj,X) RHO,...
	'xscale',	'log' ...
);

EXPORT.velocity = @(V) lib.profile.anchor(...
	'x',		@(obj) MAP.velocity.fmap(obj),...
	'xq',		@(obj,X) V,...
	'xscale',	'log' ...
);