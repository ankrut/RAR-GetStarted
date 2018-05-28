EXPORT.radius			= lib.module.ProfileMapping(1,'R');
EXPORT.radiusInverse	= lib.module.ProfileMapping(1,'1/R');
EXPORT.mass				= lib.module.ProfileMapping(1,'M');
EXPORT.massDiff			= lib.module.ProfileMapping(1,'M/R');
EXPORT.velocity			= lib.module.ProfileMapping(1,'c');
EXPORT.acceleration		= lib.module.ProfileMapping(1,'c^2/R');

EXPORT.density			= lib.module.ProfileMapping(1,'\rho');
EXPORT.particleDensity	= lib.module.ProfileMapping(1,'\rho/m');
EXPORT.particleNumber	= lib.module.ProfileMapping(1,'M/m');
EXPORT.pressure			= lib.module.ProfileMapping(1,'\rho c^2');
EXPORT.temperature		= lib.module.ProfileMapping(1,'mc^2/k_B');