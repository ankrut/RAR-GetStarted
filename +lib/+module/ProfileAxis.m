classdef ProfileAxis < lib.module.ProfileMapping
	
	methods
		function obj=ProfileAxis(varargin)
			Q = lib.module.struct(...
				'label',		'unknown',...
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
				
				case 'lib.module.ProfileMapping'
				fmap = Q.map.fmap;

				otherwise
				error('unknown map type');
			end
			
			% Q.scale is optional
			if isfield(Q,'scale')
				switch class(Q.scale)
					case 'function_handle'
					fmap = @(p) fmap(p).*Q.scale(p);
					
					case 'lib.module.ProfileMapping'
					fmap = @(p) fmap(p).*Q.scale.map(p);
						
					otherwise
					error('unknown scale type');
				end
			end
			
			obj = obj@lib.module.ProfileMapping(fmap,label);
		end
	end
end