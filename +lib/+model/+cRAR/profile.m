% REQUIERMENTS
%	lib.ecma.array
%	lib.ecma.struct
%	lib.struct
classdef profile < lib.profile.container
	methods
		function obj=profile(varargin)
			obj = obj@lib.profile.container();

			% get arguments
			Q = lib.ecma.struct(varargin{:});

			% process cases
			if isfield(Q,'model')
				obj.calc(Q.model);
			end
		end

		function obj = calc(obj,vm)
			Q = lib.struct.merge(struct(...
				'm',				[],...
				'nu0',				'Schwarzschild-surface',...
				'odeSolver',		'logarithmic',...
				'ics',				'auto',...
				'xmin',				'auto',...
				'xmax',				1E20,...	% sufficient for astrophysical cases
				'AbsTol',			1E-16,...	% absolute error for ode solver
				'RelTol',			1E-6,...	% relative error for ode solver
				'numPoints',		500,...		% for trapz integration
				'tol',				1E-15,...	% for ics = auto or xmin = auto
				'odeEventOffset',	1E-12 ...	% for odeSolver = log-alpha2
			), vm);

			% assign RAR paramater
			obj.data.m		= Q.m;
			obj.data.beta0	= Q.beta0;
			obj.data.theta0 = Q.theta0;
			obj.data.W0		= Q.W0;

			% destructor
			BETA0	= Q.beta0;
			THETA0	= Q.theta0;
			W0		= Q.W0;
			XMIN	= Q.xmin;
			XMAX	= Q.xmax;
			TOL		= Q.tol;		% how close to singularity (TOL > 0)
			NN		= Q.numPoints;	% number of points for integral

			% substitution
			ALPHA0	= 1 + THETA0*BETA0;
			EC0		= 1 + W0*BETA0;

			% define density and pressure function handles
			func_rho	= @(E,beta,alpha,ec) sqrt(E.^2 - 1).*E.^2.*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);
			func_p		= @(E,beta,alpha,ec) (E.^2 - 1).^(3/2).*(1 - exp((E - ec)./beta))./(exp((E - alpha)./beta) + 1);

			frho		= @(r,nu) 4/sqrt(pi)*real(lib.model.cRAR.integral.trapz(...
				func_rho,...
				nu,...
				BETA0,...
				ALPHA0,...
				EC0,...
				NN ...
			));

			fp			= @(r,nu) 4/3/sqrt(pi)*real(lib.model.cRAR.integral.trapz(...
				func_p,...
				nu,...
				BETA0,...
				ALPHA0,...
				EC0,...
				NN ...
			));

			function [value,isterminal,direction] = fEventNegative(x)
				value      = x;
				isterminal = 1;    % stop the integration
				direction  = -1;   % positive direction only
			end

			% set options for ODE solver
			options	= odeset(...
				'RelTol',	Q.RelTol,...
				'AbsTol',	Q.AbsTol*[1 1],...
				'Events',	@(r,y) fEventNegative((EC0*exp(-y(1)) - 1)) ...
			);

			% set initial condition
			switch class(Q.ics)
				case 'double'
				ICS = Q.ics;

				case 'char'
				switch Q.ics
					case 'auto'
					XMIN	= sqrt(6*TOL/frho(0,0));
					ICS		= [TOL, 2*TOL];							% [nu-nu0, M/R]

					case 'xmin'
					RHO0	= frho(0,0);
					ICS		= [1/6*RHO0*XMIN^2, 1/3*RHO0*XMIN^2];	% [nu-nu0, M/R]

					case 'bh'
					SCALE	= lib.ecma.require(@lib.model.cRAR.scale.SI);
					XMIN	= 3*Q.MBH/SCALE.mass.fmap(obj);			% [nu-nu0, M/R]
					ICS		= [1/2*log(2/3), 1/3];

					% assign parameter
					obj.data.MBH = Q.MBH;

					otherwise
					error('undefined initial condition')
				end

				otherwise
				error('undefined initial condition')
			end

			% call ode solver
			switch Q.odeSolver
				case 'linear'
				fode		= @(r,y) lib.model.cRAR.ode.linear(r,y,frho,fp);
				[R,Y]		= ode45(fode,[XMIN,XMAX],ICS,options);

				% convert results
				NU			= Y(:,1);
				M			= Y(:,2).*R;

				case 'logR'
				fode		= @(r,y) lib.model.cRAR.ode.logR(r,y,frho,fp);
				[X,Y]		= ode45(fode,log([XMIN,XMAX]),ICS,options);

				% increase accuracy only for the tail
				options.RelTol = 1E-15;
				[X2,Y2]		= ode45(fode,[X(end-1),log(XMAX)],Y(end-1,:),options);

				X = [X(1:end-1);X2(2:end)];
				Y = [Y(1:end-1,:);Y2(2:end,:)];

				% convert results
				R			= exp(X);
				NU			= Y(:,1);
				M			= Y(:,2).*R;

				case 'logarithmic'
				fode		= @(r,y) lib.model.cRAR.ode.logarithmic(r,y,frho,fp);
				ICS(2)		= log(ICS(2));
				[X,Y]		= ode45(fode,log([XMIN,XMAX]),ICS,options);

				% increase accuracy only for the tail
				options.RelTol = 1E-15;
				[X2,Y2]		= ode45(fode,[X(end-1),log(XMAX)],Y(end-1,:),options);

				X = [X(1:end-1);X2(2:end)];
				Y = [Y(1:end-1,:);Y2(2:end,:)];

				% convert results
				R			= exp(X);
				NU			= Y(:,1);
				M			= exp(Y(:,2)).*R;

				case 'log-alpha'
				frho		= @(r,nuA) 4/sqrt(pi)*real(lib.model.cRAR.integral.trapz(...
					func_rho,...
					nuA + log(EC0),...
					BETA0,...
					ALPHA0,...
					EC0,...
					NN ...
				));

				fp			= @(r,nuA) 4/3/sqrt(pi)*real(lib.model.cRAR.integral.trapz(...
					func_p,...
					nuA + log(EC0),...
					BETA0,...
					ALPHA0,...
					EC0,...
					NN ...
				));

				options.NonNegative	= 1;
				options.Events		= @(r,y) fEventNegative(y(1));

				fode		= @(r,y) lib.model.cRAR.ode.logAlpha(r,y,frho,fp);
				ICS(1)		= EC0*exp(-ICS(1)) - 1;
				ICS(2)		= log(ICS(2));
				[X,Y]		= ode45(fode,log([XMIN,XMAX]),ICS,options);

				% convert results
				R			= exp(X);
				NU			= -log((Y(:,1) + 1)./EC0);
				M			= exp(Y(:,2)).*R;

				case 'log-alpha2'
				frho		= @(r,nuA) 4/sqrt(pi)*real(lib.model.cRAR.integral.trapz(...
					func_rho,...
					nuA + log(EC0),...
					BETA0,...
					ALPHA0,...
					EC0,...
					NN ...
				));

				fp			= @(r,nuA) 4/3/sqrt(pi)*real(lib.model.cRAR.integral.trapz(...
					func_p,...
					nuA + log(EC0),...
					BETA0,...
					ALPHA0,...
					EC0,...
					NN ...
				));

				options.Events = @(r,y) fEventNegative(y(1) - log(Q.odeEventOffset));

				fode		= @(r,y) lib.model.cRAR.ode.logAlpha2(r,y,frho,fp);
				ICS(1)		= log(EC0*exp(-ICS(1)) - 1);
				ICS(2)		= log(ICS(2));
				[X,Y]		= ode45(fode,log([XMIN,XMAX]),ICS,options);

				% convert results
				R			= exp(X);
				NU			= -log((exp(Y(:,1)) + 1)./EC0);
				M			= exp(Y(:,2)).*R;

				otherwise
				error('unknown odeSolver method');
			end

			% cache results
			obj.data.radius			= R;
			obj.data.potential		= NU;
			obj.data.mass			= M;

			% cache time consuming variables (often needed)
			obj.data.density		= frho(R,NU);
			obj.data.pressure		= fp(R,NU);

			% set nu0
			switch class(Q.nu0)
				case 'double'
				obj.data.nu0 = Q.nu0;

				case 'function_handle'
				obj.data.nu0 = Q.nu0(obj);

				case 'char'
				fnu0 = @(nuR,MR,R) 1/2*log1p(-MR/R) - nuR; % 1/2*log(1 - M(r)/M * R/r) - [nu(r) - nu0]

				switch Q.nu0
					case 'Schwarzschild-plateau'
					ANCH = lib.ecma.require(@lib.model.cRAR.anchor);
					R	 = ANCH.mass_plateau.map('data', obj, 'y', obj.data.radius);
					nuR  = ANCH.mass_plateau.map('data', obj, 'y', obj.data.potential);
					MR	 = ANCH.mass_plateau.map('data', obj, 'y', obj.data.mass);

					obj.data.R		= R;
					obj.data.nu0	= fnu0(nuR,MR,R);

					case 'Schwarzschild-surface'
					obj.data.nu0 = fnu0(obj.data.potential(end), obj.data.mass(end), obj.data.radius(end));

					case 'box'
					nuR = lib.num.interp1('x', obj.data.radius, 'y', obj.data.potential, 'xq', Q.R, 'XScale', 'log');
					MR	= lib.num.interp1('x', obj.data.radius, 'y', obj.data.mass, 'xq', Q.R, 'XScale', 'log', 'YScale', 'log');

					obj.data.R		= Q.R;
					obj.data.nu0	= fnu0(nuR,MR,Q.R);

					otherwise
					error('undefined nu0 description')
				end

				otherwise
				error('undefined nu0 description')
			end
		end
	end
end
