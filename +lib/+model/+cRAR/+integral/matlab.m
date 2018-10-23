function f=matlab(func,NU,BETA0,ALPHA0,EPSILON0,varargin)
% preallocate (speed performance)
f = zeros(size(NU));

% cache parameter
EXPNU	= exp(-NU);
BETA	= BETA0*EXPNU;
ALPHA	= ALPHA0*EXPNU;
EPSILON = EPSILON0*EXPNU;

% calculate fermi integral for each (beta,alpha,epsilon) set
for ii = 1:length(NU)
	f(ii) = integral(@(E) func(E,BETA(ii),ALPHA(ii),EPSILON(ii)),1,EPSILON(ii),varargin{:});
end