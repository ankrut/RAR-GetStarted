% default values are given for
%	fSolution, onNaN, onEqual
%
% required parameter
%	model struct <vm>
%	search interval <Xint>
%	chi2 function <fResponse>
%	update function <fUpdate>
%	model function <fModel>
%
% optional
%	fLog
%	nlinfit options

function varargout = gosect(varargin)
% set solution function (struct => solution)
fSolution = @(vm) lib.model.cRAR.profile('model', vm);

% search for solution
[varargout{1:nargout}] = lib.fitting.gosect(...
	'fSolution',	fSolution,...
	'onNaN',		@onNaN,...
	'onEqual',		@onEqual,...
	varargin{:} ...
);

function Xint = onNaN(Xint,sLeft,sRight)
if isnan(sLeft.response) && isnan(sRight.response)
	Xint = [sRight.x, Xint(2)];
elseif isnan(sLeft.response)
	Xint = [sLeft.x, Xint(2)];
else % sRight.response has to be a NaN
	Xint = [Xint(1), sRight.x];
end

function Xint = onEqual(Xint,sLeft,sRight)
Xint = [sRight.x, Xint(2)];
