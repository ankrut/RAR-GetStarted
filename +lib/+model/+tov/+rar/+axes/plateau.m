ANCH	= lib.require(@lib.model.tov.rar.anchor);
MAP		= lib.require(@lib.model.tov.rar.map);
SCALE	= lib.require(@lib.model.tov.rar.scale.plateau);

fLabel = @(Q) lib.sprintf('$%s/%s$', Q.map.label, Q.scale.label);

% define axis
EXPORT.radius			= lib.module.ProfileAxis('map', MAP.radius,			'scale', SCALE.radius,		'label', fLabel);
EXPORT.density			= lib.module.ProfileAxis('map', MAP.cache.density,	'scale', SCALE.density,		'label', fLabel);
EXPORT.pressure			= lib.module.ProfileAxis('map', MAP.cache.pressure,	'scale', SCALE.pressure,	'label', fLabel);
EXPORT.potential		= lib.module.ProfileAxis('map', MAP.potential,		'scale', SCALE.potential,	'label', fLabel);
EXPORT.mass				= lib.module.ProfileAxis('map', MAP.mass,			'scale', SCALE.mass,		'label', fLabel);
EXPORT.velocity			= lib.module.ProfileAxis('map', MAP.velocity,		'scale', SCALE.velocity,	'label', fLabel);
EXPORT.compactness		= lib.module.ProfileAxis('map', MAP.compactness,	'scale', SCALE.compactness,	'label', fLabel);
EXPORT.degeneracy		= lib.module.ProfileAxis('map', @(obj) ANCH.velocity_plateau.map(obj,MAP.degeneracy) - MAP.degeneracy.map(obj), 'label', '$\theta_p - \theta(r)$');