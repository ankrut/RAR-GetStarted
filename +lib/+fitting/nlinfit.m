% A wrapper for the built-in nlinfit function. It works with structs rather
% than with a list of arguments.
% COUPLINGS: lib.ecma.struct
function varargout = nlinfit(varargin)
	% contract arguments with default values if not set
	Q = lib.ecma.struct(...
		'options',	statset('nlinfit'),...
		varargin{:} ...
	);

	% destructor
	vm			= Q.model;
	fResponse	= Q.fResponse;
	fUpdate		= Q.fUpdate;
	fModel		= Q.fModel;
	fSolution	= Q.fSolution;
	
	% init
	SOL = [];

	% response function hook (WIHTOUT parameter log)
	function response_values = ResponseWrapSimple(b,~)
		% update model
		vm	= fUpdate(b,vm);
		
		% calc solution
		SOL	= fSolution(vm);
		
		% update model for next iteration
		vm = fModel(SOL);
		
		% calc response values
		response_values = fResponse(SOL);
	end

	% ... WITH parameter log
	function response_values = ResponseWrapVerbose(b,~)
		% update model
		vm	= fUpdate(b,vm);
		
		% calc solution
		SOL	= fSolution(vm);
		
		% update model for next iteration
		vm = fModel(SOL);
		
		% calc response values
		response_values = fResponse(SOL);
		
		% debug
		Q.fLog(SOL);
	end

	% switch hook function
	if isfield(Q,'fLog')
		fResponseWrap = @ResponseWrapVerbose;
	else
		fResponseWrap = @ResponseWrapSimple;
	end

	% search for solution
	b = nlinfit(...
		[],...
		Q.predictions,...
		fResponseWrap,...
		Q.fVector(vm),...
		Q.options,...
		'Weight', Q.weights ...
	);

	% set output
	varargout{1} = SOL;
	varargout{2} = fModel(SOL);
	varargout{3} = sum(Q.weights.*(fResponse(SOL) - Q.predictions).^2); % chi2
end