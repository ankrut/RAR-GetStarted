classdef tov < lib.module.ProfileData
	methods
		function obj=tov(varargin)
			obj = obj@lib.module.ProfileData(varargin{:});
		end
	end
	
	
	% HELPERS: ode solver ------------------------------------------------
	methods (Static)
		function [R, NU, M] = ode_solver(ics,frho,fp,XMIN,XMAX,options)
			% ICS: [nu-nu0, M/R]
			fode	= @(r,y) lib.module.tov.odeLnR(r,y,frho,fp);
			[R,Y]	= ode45(fode,log([XMIN,XMAX]),ics,options); 

			R		= exp(R);
			NU		= Y(:,1);
			M		= Y(:,2).*R;
		end
	end
	
	
	% ODE FUNCTIONS ------------------------------------------------------
	methods (Static)
		function dy=odeLinear(x,y,frho,fp)
			dy = zeros(2,1);
			
			% x			r/R
			% y(1)		nu(r) - nu0
			% y(2)		M(r)/M * R/r
			
			% frho		density function rho(r)/rho_r
			% fp		pressure function P(r)/(rho_r c²)
			
			R		= x;
			NU		= y(1);
			PHI		= y(2);
			
			RHO		= frho(R,NU);				% density rho(r)/rho_r
			P		= fp(R,NU);					% pressure P(r)/(rho_r c²)

			% calculate derivatives
			dy(1) = (PHI + R^2*P)/(1 - PHI)/R;	% metric potential
			dy(2) = (R^2*RHO - PHI)/R;			% compatness M(r)/M * R/r
		end
		
		function dy=odeLnR(x,y,frho,fp)
			dy = zeros(2,1);
			
			% x			ln(r/R)
			% y(1)		nu(r) - nu0
			% y(2)		M(r)/M * R/r
			
			% frho		density function rho(r)/rho_r
			% fp		pressure function P(r)/(rho_r c²)
			
			R		= exp(x);
			NU		= y(1);
			PHI		= y(2);
			
			RHO		= frho(R,NU);				% density rho(r)/rho_r
			P		= fp(R,NU);					% pressure P(r)/(rho_r c²)

			% calculate derivatives
			dy(1) = (PHI + R^2*P)/(1 - PHI);	% metric potential
			dy(2) = R^2*RHO - PHI;				% compactness M(r)/M * R/r
		end

		function dy=odeLog(x,y,frho,fp)
			dy = zeros(2,1);
			
			% x			ln(r/R)
			% y(1)		nu(r) - nu0
			% y(2)		ln(M(r)/M * R/r)
			
			% frho		density function rho(r)/rho_r
			% fp		pressure function P(r)/(rho_r c²)
			
			R		= exp(x);
			NU		= y(1);
			PHI		= exp(y(2));
			
			RHO		= frho(R,NU);				% density rho(r)/rho_r
			P		= fp(R,NU);					% pressure P(r)/(rho_r c²)

			% calculate derivatives
			dy(1) = (PHI + R^2*P)/(1 - PHI);	% metric potential
			dy(2) = (R^2*RHO/PHI - 1);			% compactness ln(M(r)/M * R/r)
		end
	end
end