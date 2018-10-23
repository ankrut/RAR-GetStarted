EXPORT.radius = lib.profile.mapping(...
	'map',		@(obj) obj.data.radius,...
	'label',	'r' ...
);

EXPORT.mass = lib.profile.mapping(...
	'map',		@(obj) obj.data.mass,...
	'label',	'M(r)'...
);

EXPORT.potential = lib.profile.mapping(...
	'map',		@(obj) obj.data.potential,...
	'label',	'\nu(r) - \nu_0'...
);

EXPORT.dnudlnr = lib.profile.mapping(...
	'map',		@(obj) 0.5*(obj.data.mass./obj.data.radius + obj.data.radius.^2.*obj.data.pressure)./(1 - obj.data.mass./obj.data.radius),...
	'label',	'{\rm d}\nu/{\rm d}\ln r'...
);

EXPORT.compactness = lib.profile.mapping(...
	'map',		@(obj) obj.data.mass./obj.data.radius,...
	'label',	'\varphi(r)' ...
);

EXPORT.g00 = lib.profile.mapping(...
	'map',		@(obj) exp(2*obj.data.potential + 2*obj.data.nu0),...
	'label',	'g_{00}'...
);

EXPORT.g11 = lib.profile.mapping(...
	'map',		@(obj) 1./(1 - obj.data.mass./obj.data.radius),...
	'label',	'g_{11}'...
);

flnrho	= @(obj,x) interp1(log(obj.data.radius),log(obj.data.density),x,'pchip');
df		= @(obj,f,x,dx) (f(obj,x + dx/2) - f(obj,x - dx/2))/dx;
EXPORT.dlnrhodlnr = lib.profile.mapping(...
	'map',		@(obj) arrayfun(@(x) df(obj,flnrho,x,1E-8),log(obj.data.radius)),...
	'label',	'{\rm d}\ln\rho/{\rm d}\ln r'...
);

EXPORT.velocity = lib.profile.mapping(...
	'map',		@(obj) sqrt(EXPORT.dnudlnr.fmap(obj)),...
	'label',	'v(r)'...
);

fw = @(x) sqrt(x./(1 - x));
EXPORT.celerity = lib.profile.mapping(...
	'map',		@(obj) real(fw(EXPORT.dnudlnr.fmap(obj))),...
	'label',	'u(r)'...
);

EXPORT.density = lib.profile.mapping(...
	'map',		@(obj) obj.data.density,...
	'label',	'\rho(r)'...
);

EXPORT.pressure = lib.profile.mapping(...
	'map',		@(obj) obj.data.pressure,...
	'label',	'P(r)'...
);

EXPORT.velocity_dispersion = lib.profile.mapping(...
	'map',		@(obj) sqrt(obj.data.pressure./obj.data.density),...
	'label',	'\sigma(r)'...
);

EXPORT.effective_velocity_dispersion = lib.profile.mapping(...
	'map',		@(obj) sqrt(obj.data.pressure.*obj.data.radius.^3./obj.data.mass),...
	'label',	'\varsigma(r)'...
);

EXPORT.acceleration = lib.profile.mapping(...
	'map',		@(obj) EXPORT.velocity.fmap(obj).^2./obj.data.radius,...
	'label',	'a(r)'...
);

EXPORT.massDiff = lib.profile.mapping(...
	'map',		@(obj) obj.data.radius.^2.*EXPORT.density.fmap(obj),...
	'label',	'M''(r)'...
);

EXPORT.temperature = lib.profile.mapping(...
	'map',		@(obj) obj.data.beta0*exp(-obj.data.potential),...
	'label',	'\beta(r)'...
);

EXPORT.chemicalPotential = lib.profile.mapping(...
	'map',		@(obj) (1 + obj.data.beta0*obj.data.theta0)*exp(-obj.data.potential),...
	'label',	'\alpha(r)' ...
);

EXPORT.degeneracy = lib.profile.mapping(...
	'map',		@(obj) (EXPORT.chemicalPotential.fmap(obj) - 1)./EXPORT.temperature.fmap(obj),...
	'label',	'\theta(r)'...
);

EXPORT.potentialDiff = lib.profile.mapping(...
	'map',		@(obj) 0.5*real((obj.data.mass + obj.data.radius.^3.*obj.data.pressure)./(1 - obj.data.mass./obj.data.radius)./obj.data.radius.^2),...
	'label',	'\nu''(r)'...
);

EXPORT.temperatureDiff = lib.profile.mapping(...
	'map',		@(obj) -EXPORT.temperature.fmap(obj)*EXPORT.potentialDiff.fmap(obj),...
	'label',	'\beta''(r)'...
);

EXPORT.degeneracyDiff = lib.profile.mapping(...
	'map',		@(obj) -1./EXPORT.temperature.fmap(obj).*EXPORT.potentialDiff.fmap(obj),...
	'label',	'\theta''(r)'...
);

EXPORT.escapeEnergy = lib.profile.mapping(...
	'map',		@(obj) (1 + obj.data.beta0*obj.data.W0)*exp(-obj.data.potential),...
	'label',	'\varepsilon(r)' ...
);

EXPORT.cutoff = lib.profile.mapping(...
	'map',		@(obj) (EXPORT.escapeEnergy.fmap(obj) - 1)./EXPORT.temperature.fmap(obj),...
	'label',	'W(r)'...
);

EXPORT.cutoffDiff = lib.profile.mapping(...
	'map',		@(obj) -1./EXPORT.temperature.fmap(obj).*EXPORT.potentialDiff.fmap(obj),...
	'label',	'W''(r)'...
);


% define density and pressure function handles
integralSettings = struct(...
	'func', @lib.model.cRAR.integral.trapz,...
	'arg',	{{500}} ...
);

func_n		= @(E,beta,alpha,ec) (1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1).*sqrt(E.^2 - 1).*E;
func_rho	= @(E,beta,alpha,ec) (1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1).*sqrt(E.^2 - 1).*E.^2;
func_p		= @(E,beta,alpha,ec) (1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1).*(E.^2 - 1).^(3/2);

fn = @(obj) real(4/sqrt(pi)*integralSettings.func(...
	func_n,...
	obj.data.potential,...
	obj.data.beta0,...
	(1 + obj.data.beta0*obj.data.theta0),...
	(1 + obj.data.beta0*obj.data.W0),...
	integralSettings.arg{:} ...
));

fN = @(obj) cumtrapz(obj.data.radius,(1 - obj.data.mass./obj.data.radius).^(-1/2).*fn(obj).*obj.data.radius.^2);

frho = @(obj) real(4/sqrt(pi)*integralSettings.func(...
	func_rho,...
	obj.data.potential,...
	obj.data.beta0,...
	(1 + obj.data.beta0*obj.data.theta0),...
	(1 + obj.data.beta0*obj.data.W0),...
	integralSettings.arg{:} ...
));

fP = @(obj) real(4/3/sqrt(pi)*integralSettings.func(...
	func_p,...
	obj.data.potential,...
	obj.data.beta0,...
	(1 + obj.data.beta0*obj.data.theta0),...
	(1 + obj.data.beta0*obj.data.W0),...
	integralSettings.arg{:} ...
));

EXPORT.particleDensity = lib.profile.mapping(...
	'map',		fn,...
	'label',	'n(r)' ...
);

EXPORT.particleNumber = lib.profile.mapping(...
	'map',		fN,...
	'label',	'N(r)' ...
);

EXPORT.density = lib.profile.mapping(...
	'map',		frho,...
	'label',	'\rho(r)' ...
);

EXPORT.pressure = lib.profile.mapping(...
	'map',		fP,...
	'label',	'P(r)' ...
);


% experimental
func_vRMS1	= @(E,beta,alpha,ec) sqrt(E.^2 - 1)./E.*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);
func_vRMS2	= @(E,beta,alpha,ec) sqrt(E.^2 - 1).*E.*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);

fvRMS1 = @(obj) integralSettings.func(...
	func_vRMS1,...
	obj.data.potential,...
	obj.data.beta0,...
	(1 + obj.data.beta0*obj.data.theta0),...
	(1 + obj.data.beta0*obj.data.W0),...
	integralSettings.arg{:} ...
);

fvRMS2 = @(obj) integralSettings.func(...
	func_vRMS2,...
	obj.data.potential,...
	obj.data.beta0,...
	(1 + obj.data.beta0*obj.data.theta0),...
	(1 + obj.data.beta0*obj.data.W0),...
	integralSettings.arg{:} ...
);

EXPORT.velocityRMS = lib.profile.mapping(...
	'map',		@(obj) sqrt(1 - fvRMS1(obj)./fvRMS2(obj)),...
	'label',	'\sigma(r)' ...
);


func_pRMS1	= @(E,beta,alpha,ec) sqrt(E.^2 - 1).*E.^3.*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);
func_pRMS2	= @(E,beta,alpha,ec) sqrt(E.^2 - 1).*E.*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);

fpRMS1 = @(obj) integralSettings.func(...
	func_pRMS1,...
	obj.data.potential,...
	obj.data.beta0,...
	(1 + obj.data.beta0*obj.data.theta0),...
	(1 + obj.data.beta0*obj.data.W0),...
	integralSettings.arg{:} ...
);

fpRMS2 = @(obj) integralSettings.func(...
	func_pRMS2,...
	obj.data.potential,...
	obj.data.beta0,...
	(1 + obj.data.beta0*obj.data.theta0),...
	(1 + obj.data.beta0*obj.data.W0),...
	integralSettings.arg{:} ...
);

EXPORT.momentumRMS = lib.profile.mapping(...
	'map',		@(obj) sqrt(fpRMS1(obj)./fpRMS2(obj) - 1),...
	'label',	'\varpi(r)' ...
);



% map CACHED data
EXPORT.cache.density = lib.profile.mapping(...
	'map',		@(obj) obj.data.density,...
	'label',	'\rho(r)' ...
);

EXPORT.cache.pressure = lib.profile.mapping(...
	'map',		@(obj) obj.data.pressure,...
	'label',	'P(r)' ...
);

% map (reduced) profiles
EXPORT.schwarzschild = lib.profile.mapping(...
	'map',		@(obj) lib.model.Schwarzschild.profile(...
		'nu0',		obj.data.nu0,...
		'M0',		obj.data.MBH,...
		'radius',	obj.data.radius./obj.data.mass(1) ...
	),...
	'label',	'Schwarzschild solution' ...
);
