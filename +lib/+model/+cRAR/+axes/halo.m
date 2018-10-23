ANCH	= lib.ecma.require(@lib.model.cRAR.anchor);
MAP		= lib.ecma.require(@lib.model.cRAR.map);
SCALE	= lib.ecma.require(@lib.model.cRAR.scale.halo);

fLabel = @(Q) lib.char.sprintf('$%s/%s$', Q.map.label, Q.scale.label);

% define axis
EXPORT.radius			= lib.profile.axis('map', MAP.radius,			'scale', SCALE.radius,		'label', fLabel);
EXPORT.density			= lib.profile.axis('map', MAP.cache.density,	'scale', SCALE.density,		'label', fLabel);
EXPORT.pressure			= lib.profile.axis('map', MAP.cache.pressure,	'scale', SCALE.pressure,	'label', fLabel);
EXPORT.potential		= lib.profile.axis('map', MAP.potential,		'scale', SCALE.potential,	'label', fLabel);
EXPORT.mass				= lib.profile.axis('map', MAP.mass,				'scale', SCALE.mass,		'label', fLabel);
EXPORT.velocity			= lib.profile.axis('map', MAP.velocity,			'scale', SCALE.velocity,	'label', fLabel);
EXPORT.compactness		= lib.profile.axis('map', MAP.compactness,		'scale', SCALE.compactness,	'label', fLabel);
EXPORT.degeneracy		= lib.profile.axis('map', @(obj) ANCH.velocity_halo.map(obj,MAP.degeneracy) - MAP.degeneracy.map(obj), 'label', '$\theta_h - \theta(r)$');