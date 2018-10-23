MAP		= lib.ecma.require(@lib.model.cRAR.map);
SCALE	= lib.ecma.require(@lib.model.cRAR.scale.natural);

fLabelScale		= @(Q) lib.char.sprintf('$%s/%s$', Q.map.label, Q.scale.label);
fLabelUnit		= @(Q) lib.char.sprintf('$%s\quad[%s]$', Q.map.label, Q.scale.label);
fLabelUnitless	= @(Q) lib.char.sprintf('$%s$', Q.map.label);

% define axis
EXPORT.velocity			= lib.profile.axis('map',	MAP.velocity,		'scale', SCALE.velocity,	'label', fLabelScale);

