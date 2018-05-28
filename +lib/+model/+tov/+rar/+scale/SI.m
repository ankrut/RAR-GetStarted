lib.module.constraints

% SI SCALE
EXPORT.radius = lib.module.ProfileMapping(...
	@(obj) pi^(1/4)/sqrt(2)*(mp/obj.data.m)^2*lp,...
	'\mathrm{m}' ...
);

EXPORT.mass = lib.module.ProfileMapping(...
	@(obj) 1/2*pi^(1/4)/sqrt(2)*(mp/obj.data.m)^2*mp,...
	'\mathrm{kg}'...
);

EXPORT.velocity = lib.module.ProfileMapping(...
	c,...
	'\mathrm{m/s}'...
);

EXPORT.acceleration = lib.module.ProfileMapping(...
	@(obj) c^2/EXPORT.radius.map(obj),...
	'\mathrm{m/s^2}'...
);

EXPORT.density = lib.module.ProfileMapping(...
	@(obj) 2*obj.data.m^4/h^3*c^3*pi^(3/2),...
	'\mathrm{kg}/\mathrm{m}^3');

EXPORT.particledensity = lib.module.ProfileMapping(...
	@(obj) EXPORT.density.map(obj)/obj.data.m,...
	'\mathrm{m}^{-3}');

EXPORT.particleNumber = lib.module.ProfileMapping(...
	@(obj) EXPORT.mass.map(obj)/obj.data.m,...
	'');

EXPORT.pressure = lib.module.ProfileMapping(...
	@(obj) EXPORT.density.map(obj)*c^2,...
	'N/m^2'...
);

EXPORT.particle_mass = lib.module.ProfileMapping(...
	@(obj) obj.data.m,...
	'\mathrm{kg}'...
);

EXPORT.temperature = lib.module.ProfileMapping(...
	@(obj) obj.data.m*c^2/kB,...
	'K'...
);