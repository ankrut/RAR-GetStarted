MAP		= lib.ecma.require(@lib.model.cRAR.map);
SCALE	= lib.ecma.require(@lib.model.cRAR.scale.raw);

fLabelUnit		= @(Q) lib.char.sprintf('$%s/%s$', Q.map.label, Q.scale.label);
fLabelUnitless	= @(Q) lib.char.sprintf('$%s$', Q.map.label);

% define axis
EXPORT.radius			= lib.profile.axis('map', MAP.radius,				'scale', SCALE.radius,			'label', fLabelUnit);
EXPORT.density			= lib.profile.axis('map', MAP.cache.density,		'scale', SCALE.density,			'label', fLabelUnit);
EXPORT.pressure			= lib.profile.axis('map', MAP.cache.pressure,		'scale', SCALE.pressure,		'label', fLabelUnit);
EXPORT.mass				= lib.profile.axis('map', MAP.mass,					'scale', SCALE.mass,			'label', fLabelUnit);
EXPORT.velocity			= lib.profile.axis('map', MAP.velocity,				'scale', SCALE.velocity,		'label', fLabelUnit);
EXPORT.velDisp			= lib.profile.axis('map', MAP.velocity_dispersion,	'scale', SCALE.velocity,		'label', fLabelUnit);
EXPORT.massDiff			= lib.profile.axis('map', MAP.massDiff,				'scale', SCALE.radiusInverse,	'label', fLabelUnit);
EXPORT.degeneracyDiff	= lib.profile.axis('map', MAP.degeneracyDiff,		'scale', SCALE.radiusInverse,	'label', fLabelUnit);

EXPORT.potential		= lib.profile.axis('map', MAP.potential,	'label', fLabelUnitless);
EXPORT.compactness		= lib.profile.axis('map', MAP.compactness,	'label', fLabelUnitless);
EXPORT.degeneracy		= lib.profile.axis('map', MAP.degeneracy,	'label', fLabelUnitless);
EXPORT.cutoff			= lib.profile.axis('map', MAP.cutoff,		'label', fLabelUnitless);