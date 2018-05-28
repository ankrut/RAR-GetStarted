MAP		= lib.require(@lib.model.tov.rar.map);
SCALE	= lib.require(@lib.model.tov.rar.scale.astro);

fLabel = @(Q) lib.sprintf('$%s\quad[%s]$', Q.map.label, Q.scale.label);

% define axis
EXPORT.radius			= lib.module.ProfileAxis('map', MAP.radius,			'scale', SCALE.radius,			'label', fLabel);
EXPORT.density			= lib.module.ProfileAxis('map', MAP.cache.density,	'scale', SCALE.density,			'label', fLabel);
EXPORT.pressure			= lib.module.ProfileAxis('map', MAP.cache.pressure,	'scale', SCALE.pressure,		'label', fLabel);
EXPORT.mass				= lib.module.ProfileAxis('map', MAP.mass,			'scale', SCALE.mass,			'label', fLabel);
EXPORT.velocity			= lib.module.ProfileAxis('map', MAP.velocity,		'scale', SCALE.velocity,		'label', fLabel);
EXPORT.velocityRMS		= lib.module.ProfileAxis('map', MAP.velocityRMS,	'scale', SCALE.velocity,		'label', fLabel);
EXPORT.massDiff			= lib.module.ProfileAxis('map', MAP.massDiff,		'scale', SCALE.massDiff,		'label', fLabel);
EXPORT.degeneracyDiff	= lib.module.ProfileAxis('map', MAP.degeneracyDiff,	'scale', SCALE.degeneracyDiff,	'label', fLabel);
