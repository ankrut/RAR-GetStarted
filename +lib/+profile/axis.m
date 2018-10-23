classdef axis < lib.profile.mapping
	
	methods
		function obj=axis(varargin)
			Q = lib.ecma.struct(...
				'label',		'not labeled',...
				varargin{:} ...
			);
			
			% Q.label is optional (but recommended)			
			switch class(Q.label)
				case 'char'
				label = Q.label;
				
				case 'function_handle'
				if isfield(Q,'scale')
					label = Q.label(struct('map', Q.map, 'scale', Q.scale));
				else
					label = Q.label(struct('map', Q.map));
				end
					
				otherwise
				error('unknown label type');
			end
			
			% Q.map is required
			switch class(Q.map)
				case 'function_handle'
				fmap = Q.map;
				
				case 'lib.profile.mapping'
				fmap = Q.map.fmap;

				otherwise
				error('unknown map type');
			end
			
			% Q.scale is optional
			if isfield(Q,'scale')
				switch class(Q.scale)
					case 'function_handle'
					fmap = @(p) fmap(p).*Q.scale('data', p);
					
					case 'lib.profile.mapping'
					fmap = @(p) fmap(p).*Q.scale.map('data', p);
						
					otherwise
					error('unknown scale type');
				end
			end
			
			obj = obj@lib.profile.mapping(...
				'map',		fmap,...
				'label',	label ...
			);
		end
	end
end