function main
% load packages
CONST = lib.ecma.require(@lib.physics.constants);

% set model parameter function
fModel = @(beta0, theta0, W0) struct(...
	'm',		48*CONST.keVcc,...
	'beta0',	beta0,...
	'theta0',	theta0,...
	'W0',		W0,...
	'xmax',		1E15,...
	'RelTol',	1E-6 ...
);

% set theta0 grid
THETA0 = lib.ecma.array([0 2 5 10 15 20]);

% calculate profiles
% NOTE: W0 = 150 describes here solutions effectively without evaporation effects
fMap = @(theta0) lib.model.cRAR.profile('model', fModel(1E-6,theta0,150));
STORE.profiles = THETA0.map(fMap);

% save
lib.view.file.mat('+script/+calc/STORE.mat',STORE);