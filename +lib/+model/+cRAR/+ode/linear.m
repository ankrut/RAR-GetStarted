function dy=linear(x,y,frho,fp)
dy = zeros(2,1);

% x			r/R
% y(1)		nu(r) - nu0
% y(2)		M(r)/M * R/r

% frho		density function rho(r)/rho
% fp		pressure function P(r)/(rho c²)

R		= x;
NU		= y(1);
PHI		= y(2);

RHO		= frho(R,NU);					% density rho(r)/rho
P		= fp(R,NU);						% pressure P(r)/(rho c²)

% calculate derivatives
dy(1) = 0.5*(PHI + R^2*P)/(1 - PHI)/R;	% metric potential
dy(2) = (R^2*RHO - PHI)/R;				% compactness M(r)/M * R/r