classdef anchor < handle
	properties
		fx
		fxq
		xscale
	end
	
	methods
		function obj=anchor(varargin)
			Q = lib.ecma.struct(...
				'scale',	'linear',...
				varargin{:} ...
			);
		
			obj.fx		= Q.x;
			obj.fxq		= Q.xq;
			obj.xscale	= Q.xscale;
		end
		
		function Yq = map(obj,varargin)
			Q = lib.ecma.struct(...
				'interp1', {...
					'XScale', obj.xscale ...
				},...
				varargin{:} ...
			);
		
			
			% get x values and anchor point
			X		= obj.fx(Q.data);
			Xq		= obj.fxq(Q.data,X);
			
			% get y values
			switch class(Q.y)
				case 'double'
				Y = Q.y;

				case 'function_handle'
				Y = Q.y(Q.data);

				case {'lib.profile.axis','lib.profile.mapping'}
				Y = Q.y.fmap(Q.data);

				otherwise
				error('undefined map argument');
			end

			% get y value at anchor point
			Yq = lib.num.interp1(...
				'x',	X,...
				'y',	Y,...
				'xq',	Xq,...
				Q.interp1{:} ...
			);
		end
	end
end