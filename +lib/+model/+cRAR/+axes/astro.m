MAP		= lib.ecma.require(@lib.model.cRAR.map);
SCALE	= lib.ecma.require(@lib.model.cRAR.scale.astro);

fLabel = @(Q) lib.char.sprintf('$%s\quad[%s]$', Q.map.label, Q.scale.label);

% define axis
EXPORT.radius			= lib.profile.axis('map', MAP.radius,			'scale', SCALE.radius,			'label', fLabel);
EXPORT.density			= lib.profile.axis('map', MAP.cache.density,	'scale', SCALE.density,			'label', fLabel);
EXPORT.pressure			= lib.profile.axis('map', MAP.cache.pressure,	'scale', SCALE.pressure,		'label', fLabel);
EXPORT.mass				= lib.profile.axis('map', MAP.mass,				'scale', SCALE.mass,			'label', fLabel);
EXPORT.velocity			= lib.profile.axis('map', MAP.velocity,			'scale', SCALE.velocity,		'label', fLabel);
EXPORT.velocityRMS		= lib.profile.axis('map', MAP.velocityRMS,		'scale', SCALE.velocity,		'label', fLabel);
EXPORT.massDiff			= lib.profile.axis('map', MAP.massDiff,			'scale', SCALE.massDiff,		'label', fLabel);
EXPORT.degeneracyDiff	= lib.profile.axis('map', MAP.degeneracyDiff,	'scale', SCALE.degeneracyDiff,	'label', fLabel);
