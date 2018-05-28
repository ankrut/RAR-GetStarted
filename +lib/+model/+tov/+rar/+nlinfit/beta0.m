function varargout = beta0(vm,list,varargin)
% set iteration print function
sPrec	= '%1.15e';
sStrong = ['<strong>' sPrec '</strong>'];
sFormat = strjoin({sStrong,sPrec,sPrec,'%1.3e\n'},'\t');
fLog	= @(SOL) fprintf(sFormat,SOL.data.beta0,SOL.data.theta0,SOL.data.W0,list.chi2(SOL));

% set vector function
fVector = @(vm) [
	log(vm.param.beta0)
];



% set update function
fUpdate = @(b,vm) struct(...
	'param', struct(...
		'beta0',	exp(b(1)),...
		'theta0',	vm.param.theta0,...
		'W0',		vm.param.W0 ...
	),...
	'options',	vm.options ...
);

% seach for solution
[varargout{1:nargout}] = lib.model.tov.rar.nlinfit(vm,list,...
	'fVector',		fVector,...
	'fUpdate',		fUpdate,...
	'fLog',			fLog,...
	varargin{:} ...
);