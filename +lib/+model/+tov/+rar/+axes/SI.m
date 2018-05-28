MAP		= lib.require(@lib.model.tov.rar.map);
SCALE	= lib.require(@lib.model.tov.rar.scale.SI);

fLabelUnit		= @(Q) lib.sprintf('$%s\quad[%s]$', Q.map.label, Q.scale.label);
fLabelUnitless	= @(Q) lib.sprintf('$%s$', Q.map.label);

% define axis
EXPORT.radius			= lib.module.ProfileAxis('map',	MAP.radius,					'scale', SCALE.radius,	'label', fLabelUnit);
EXPORT.density			= lib.module.ProfileAxis('map',	MAP.cache.density,			'scale', SCALE.density,	'label', fLabelUnit);
EXPORT.pressure			= lib.module.ProfileAxis('map',	MAP.cache.pressure,			'scale', SCALE.pressure,	'label', fLabelUnit);
EXPORT.mass				= lib.module.ProfileAxis('map',	MAP.mass,					'scale', SCALE.mass,		'label', fLabelUnit);
EXPORT.velocity			= lib.module.ProfileAxis('map',	MAP.velocity,				'scale', SCALE.velocity,	'label', fLabelUnit);
EXPORT.velDisp			= lib.module.ProfileAxis('map',	MAP.velocity_dispersion,	'scale', SCALE.velocity,	'label', fLabelUnit);
EXPORT.speedOfSound		= lib.module.ProfileAxis('map',	MAP.velocitySOS,			'scale', SCALE.velocity,	'label', fLabelUnit);
EXPORT.acceleration		= lib.module.ProfileAxis('map',	MAP.acceleration,			'scale', SCALE.acceleration,	'label', fLabelUnit);

EXPORT.particleNumber	= lib.module.ProfileAxis('map',	MAP.particleNumber,			'scale', SCALE.particleNumber,	'label', sprintf('$%s$', MAP.particleNumber.label));

EXPORT.potential		= lib.module.ProfileAxis('map',	MAP.potential,		'label', fLabelUnitless);
EXPORT.compactness		= lib.module.ProfileAxis('map',	MAP.compactness,	'label', fLabelUnitless);
EXPORT.degeneracy		= lib.module.ProfileAxis('map',	MAP.degeneracy,		'label', fLabelUnitless);
EXPORT.cutoff			= lib.module.ProfileAxis('map',	MAP.cutoff,			'label', fLabelUnitless);
