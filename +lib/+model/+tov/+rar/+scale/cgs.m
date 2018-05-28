lib.module.constraints
SCALE	= lib.require(@lib.model.tov.rar.scale.astro);

EXPORT.density = lib.module.ProfileMapping(...
	@(obj) SCALE.density.map(obj)/1E-3,...
	'\mathrm{g}/\mathrm{cm}^3');