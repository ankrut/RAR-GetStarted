function cache
% load packages
CONST = lib.require(@lib.module.constants);

% set model parameter function
fModel = @(beta0, theta0, W0) struct(...
	'param',	struct('m', 48*CONST.keVcc, 'beta0', beta0, 'theta0', theta0, 'W0', W0),...
	'options',	struct('xmax', 1E15, 'tau', 1E-16, 'rtau', 1E-4)...
);

% set theta0 grid
THETA0 = lib.module.array([0 2 5 10 15 20]);

% calculate profiles (without evaporation effects
fMap = @(theta0) lib.model.tov.rar.profile('model', fModel(1E-6,theta0,150));
TBL.profiles = THETA0.map(fMap);

% save
lib.save('+view/+radius_density/CACHE.mat',TBL);