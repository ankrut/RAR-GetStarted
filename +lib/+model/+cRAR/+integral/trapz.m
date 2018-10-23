function f=trapz(func,NU,BETA0,ALPHA0,EPSILON0,NN)
% preallocate (speed performance)
f = zeros(size(NU));

% cache parameter
EXPNU	= exp(-NU);
BETA	= BETA0*EXPNU;
ALPHA	= ALPHA0*EXPNU;
EPSILON = EPSILON0*EXPNU;

% calculate fermi integral for each (beta,alpha,epsilon) set
for ii = 1:length(NU)
	E = linspace(1,EPSILON(ii),NN);
	f(ii) = trapz(E,func(E,BETA(ii),ALPHA(ii),EPSILON(ii)));
end