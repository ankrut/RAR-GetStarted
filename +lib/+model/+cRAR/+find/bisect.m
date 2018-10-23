function varargout = bisect(varargin)
% set solution function (struct => solution)
fSolution = @(vm) lib.model.cRAR.profile('model', vm);

% set default bisect options
opts = struct(...
	'tau',		1E-6,...
	'MaxIter',	40 ...
);

% search for solution
[varargout{1:nargout}] = lib.fitting.bisect(...
	'fSolution',	fSolution,...
	'onNaN',		@onNaN,...
	'options',		opts,...
	varargin{:} ...
);


function [Xint,dY] = onNaN(Xint,dY)
if isnan(dY(1)) && isnan(dY(3))
	error('badly chosen interval. Interval edges give NaN.')
elseif isnan(dY(1))
	if sign(dY(2)) == sign(dY(3)) && abs(dY(2)) < abs(dY(3))
		Xint = [Xint(1), mean(Xint)];
		dY(3) = dY(2);
	else
		Xint = [mean(Xint), Xint(2)];
		dY(1) = dY(2);
	end
elseif isnan(dY(3))
	if sign(dY(2)) == sign(dY(1)) && abs(dY(2)) < abs(dY(1))
		Xint = [mean(Xint),Xint(2)];
		dY(1) = dY(2);
	else
		Xint = [Xint(1), mean(Xint)];
		dY(3) = dY(2);
	end
end