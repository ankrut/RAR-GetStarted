% REQUIERMENTS
%	lib.module.tov
%	lib.module.array
%	lib.module.struct
%	lib.struct
classdef profile < lib.module.tov
	properties (Access = private)
		MAP		= lib.require(@lib.model.tov.rar.map);
		SCALE	= lib.require(@lib.model.tov.rar.scale.SI);
	end
	
	methods
		function obj=profile(varargin)
			obj = obj@lib.module.tov();
			
			if nargin > 0
				Q = lib.module.struct(...
					'makeup', false,...
					varargin{:} ...
				);

				if isfield(Q,'param')
					obj.define(Q.param);
				end

				if isfield(Q,'options')
					obj.calc(Q.options);
				end

				if isfield(Q,'model')
					obj.define(Q.model.param).calc(Q.model.options);
				end
				
				if Q.makeup
					obj.data.radius(1)		= realmin;
					obj.data.density(end)	= realmin;
					obj.data.pressure(end)	= realmin;
				end
			end
		end
		
		function obj=define(obj,s)
			lib.module.array(fieldnames(s)).forEach(@(key) ...
				obj.set(key,s.(key)) ...
			);
		end
		
		function obj=calc(obj,opts)
			% destructor
			THETA0	= obj.data.theta0;
			W0		= obj.data.W0;
			BETA0	= obj.data.beta0;
			
			CELL = lib.struct.toCell(opts);
			Q = lib.module.struct(...
				'xmin',			'auto',...
				'xmax',			1E20,...
				'tau',			1E-16,...
				'rtau',			1E-4,...
				'tol',			1E-15,...
				'numPoints',	500,...
				CELL{:} ...
			);
		
			XMIN	= Q.xmin;
			XMAX	= Q.xmax;
			TOL		= Q.tol;		% how close to singularity (TOL > 0)
			TAU		= Q.tau;		% absolute error for ode solver
			RTAU	= Q.rtau;		% relative error for ode solver
			NN		= Q.numPoints;	% number of points for integral
			
			
			tt = cputime;
			dt = 10; % sec;
			
			function [value,isterminal,direction] = fMaxExecutionTime()
				value		= dt - (cputime - tt);
				isterminal	= 1;
				direction	= 0;
			end
			
			function [value,isterminal,direction] = fEventNegative(x)
				value      = real(x);
				isterminal = 1;    % stop the integration
				direction  = -1;   % positive direction only
			end
			
			function [value,isterminal,direction] = fEvent(x)
				[value(1),isterminal(1),direction(1)] = fMaxExecutionTime();
				[value(2),isterminal(2),direction(2)] = fEventNegative(x);
			end
			
			% substitution
			ALPHA0	= 1 + THETA0*BETA0;
			EC0		= 1 + W0*BETA0;
			
			% define density and pressure function handles
			func_rho	= @(E,beta,alpha,ec) sqrt(E.^2 - 1).*E.^2.*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);
			func_p		= @(E,beta,alpha,ec) (E.^2 - 1).^(3/2).*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);
			frho		= @(r,nu) real(4/sqrt(pi)*lib.model.tov.rar.integral.trapz(func_rho,BETA0*exp(-nu./2),ALPHA0*exp(-nu./2),EC0*exp(-nu./2),NN));
			fp			= @(r,nu) real(4/3/sqrt(pi)*lib.model.tov.rar.integral.trapz(func_p,BETA0*exp(-nu./2),ALPHA0*exp(-nu./2),EC0*exp(-nu./2),NN));
			
			% set OPTIONS (for ODE solver)
			fevent	= @(r,y) fEvent(EC0*exp(-y(1)/2) - 1); % check cutoff condition
			options	= odeset('RelTol',RTAU,'AbsTol',TAU*[1 1],'Event',fevent);
			
			if strcmp(XMIN,'auto')
				XMIN = sqrt(6*TOL/frho(0,0));
				
				if isinf(XMIN) || isnan(XMIN)
					error('derived xmin is ill (Inf or NaN)');
				end
			end
			
			% call ode solver for nu(r)-nu0 and M(r)
			RHO0		= frho(0,0);
			ICS			= [1/6*RHO0*XMIN^2, 1/3*RHO0*XMIN^2];
			[R, NU, M]	= lib.module.tov.ode_solver(ICS,frho,fp,XMIN,XMAX,options);
			
			obj.data.radius			= R;
			obj.data.potential		= NU;
			obj.data.mass			= M;
			
			% cache time consuming variables (often needed)
			obj.data.density		= frho(R,NU);
			obj.data.pressure		= fp(R,NU);
		end
	end
	
	
	% CORRESPONDING PROFILES ---------------------------------------------
	methods
		function p = getVacuumSolution(obj,varargin)
			% create object
			p = lib.model.elementary.pointlike.profile(obj.data.mass(end));
			
			% set scale factors (convert RAW -> SI)
			p.set('R', obj.SCALE.radius.map(obj));
			p.set('M', obj.SCALE.mass.map(obj));
			
			% optional
			Q = lib.module.struct(...
				'numPoints',	50,...
				'xmin',			obj.data.radius(end),...
				varargin{:} ...
			);
		
			% destructure
			XMIN = Q.xmin;
			
			if isfield(Q,'rmin') % rmin in SI units (m)
				if ischar(Q.rmin) && strcmp(Q.rmin,'horizon')
					XMIN = p.data.M0 + eps;
				else
					XMIN = Q.rmin/obj.SCALE.radius.map(obj);
				end
			end
			
			if isfield(Q,'rmax') % rmax in SI units (m)
				XMAX = Q.rmax/obj.SCALE.radius.map(obj);
				p.set('radius', logspace(log10(XMIN),log10(XMAX),Q.numPoints));
			end
		end
	end
end