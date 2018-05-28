classdef ProfileMapping < handle
	properties
		fmap		% function handle
		label		% label of mapping (e.g. '\theta_0')
	end
	
	methods
		function obj=ProfileMapping(fmap,label)
			switch class(fmap)
				case 'function_handle'
				obj.fmap = fmap;
				
				otherwise
				obj.fmap = @(obj) fmap;
			end
			
			obj.label = label;
		end
		
		function data=map(obj,profile)
			data = obj.fmap(profile);
		end
	end
end