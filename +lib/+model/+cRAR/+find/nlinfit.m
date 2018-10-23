function varargout = nlinfit(varargin)
Q = lib.ecma.struct(...
	varargin{:} ...
);

% parse parameter
PARAM = parseParameter(Q.parameter);

% set iteration print function
sPrec	= '%1.12e';
sStrong = ['<strong>' sPrec '</strong>'];
sFormat	= PARAM.map(@(t) lib.bool.iff(isfield(t,'fVector'),sStrong,sPrec)).data;
fLog	= @(SOL) fprintf('%1.3e\t%s\n',Q.list.chi2(SOL),PARAM.map(@(t,ii) sprintf(sFormat{ii},t.fLog(SOL))).join('\t'));

% set predictions and weights
predictions = Q.list.stream(@(elm) elm.prediction)';
weights		= Q.list.stream(@(elm) elm.weight)';

% set response function
fResponse = @(SOL) Q.list.stream(@(elm) elm.map('data', SOL))';

% set solution function
fSolution = @(vm) lib.model.cRAR.profile('model', vm);

% set vector function
Tvector = PARAM.filter(@(t) isfield(t,'fVector'));
fVector = @(vm) Tvector.accumulate(@(t) t.fVector(vm));

% set update function
Tupdate = PARAM.filter(@(t) isfield(t,'fUpdate'));
fUpdate = @(b,vm) lib.struct.setfield(vm, Tupdate.map(@(t,ii) ...
	struct('path', t.path', 'value', t.fUpdate(b(ii))) ...
));

% set model function
fModel = @(SOL) lib.struct.setfield(Q.model, PARAM.map(@(t) ...
	struct('path', t.path', 'value', t.fModel(SOL)) ...
));

% set options
opts = statset('nlinfit');
opts.FunValCheck = 'off';

% seach for solution
[varargout{1:nargout}] = lib.fitting.nlinfit(...
	'predictions',	predictions,...
	'weights',		weights,...
	'fResponse',	fResponse,...
	'fSolution',	fSolution,...
	'fVector',		fVector,...
	'fUpdate',		fUpdate,...
	'fModel',		fModel,...
	'fLog',			fLog,...
	'options',		opts,...
	varargin{:} ...
);

function arr = parseParameter(T)
arr  = lib.ecma.array();
list = fieldnames(T);

for ii = 1:numel(list)
	key = list{ii};
	
	switch key
		case 'm'
		CONST = lib.ecma.require(@lib.physics.constants);
		obj = struct(...
			'path',		'm',...
			'fModel',	@(SOL) SOL.data.m,...
			'fLog',		@(SOL) SOL.data.m/CONST.keVcc ...
		);
	
		fVectorLinear	= @(vm)  vm.m;
		fVectorLog		= @(vm)  log(vm.m);

		case 'beta0'
		obj = struct(...
			'path',		'beta0',...
			'fModel',	@(SOL) SOL.data.beta0,...
			'fLog',		@(SOL) SOL.data.beta0 ...
		);
	
		fVectorLinear	= @(vm)  vm.beta0;
		fVectorLog		= @(vm)  log(vm.beta0);

		case 'theta0'
		obj = struct(...
			'path',		'theta0',...
			'fModel',	@(SOL) SOL.data.theta0,...
			'fLog',		@(SOL) SOL.data.theta0 ...
		);
	
		fVectorLinear	= @(vm)  vm.theta0;
		fVectorLog		= @(vm)  log(vm.theta0);

		case 'W0'
		obj = struct(...
			'path',		'W0',...
			'fModel',	@(SOL) SOL.data.W0,...
			'fLog',		@(SOL) SOL.data.W0 ...
		);
	
		fVectorLinear	= @(vm)  vm.W0;
		fVectorLog		= @(vm)  log(vm.W0);

		case 'Wp'
		obj = struct(...
			'path',		'Wp',...
			'fModel',	@(SOL) SOL.data.Wp,...
			'fLog',		@(SOL) SOL.data.Wp ...
		);
	
		fVectorLinear	= @(vm)  vm.Wp;
		fVectorLog		= @(vm)  log(vm.Wp);

		otherwise
			error('unknown parameter key');
	end
	
	switch T.(key)
		case 'linear'
		obj.fVector = fVectorLinear;
		obj.fUpdate = @(b) b;
		
		case 'log'
		obj.fVector = fVectorLog;
		obj.fUpdate = @(b) exp(b);
	end
	
	arr.push(obj);
end