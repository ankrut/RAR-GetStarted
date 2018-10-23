MAP		= lib.ecma.require(@lib.model.cRAR.map);
SCALE	= lib.ecma.require(@lib.model.cRAR.scale.center);


fLabel = @(Q) lib.char.sprintf('$%s/%s$', Q.map.label, Q.scale.label);

% define axis
EXPORT.density			= lib.profile.axis('map', MAP.cache.density,		'scale', SCALE.density,		'label', fLabel);
EXPORT.pressure			= lib.profile.axis('map', MAP.cache.pressure,		'scale', SCALE.pressure,	'label', fLabel);
EXPORT.degeneracy		= lib.profile.axis('map', @(obj) obj.data.theta0 - MAP.degeneracy.map(obj), 'label', '$\theta_0 - \theta(r)$');