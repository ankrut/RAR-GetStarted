classdef response < lib.profile.mapping
	properties
		prediction
		weight
	end
	
	methods
		function obj = response(varargin)
			Q = lib.ecma.struct(...
				varargin{:} ...
			);
			
			obj = obj@lib.profile.mapping(varargin{:});
			
			obj.prediction	= Q.prediction;
			
			if isfield(Q,'weight')
				obj.weight = Q.weight;
			else
				obj.weight = 1./Q.prediction.^2;
			end
		end
		
		function x=chi2(obj,profile)
			switch class(obj.prediction)
				case 'char'
					switch obj.prediction
						case 'min'
						x = obj.fmap(profile);

						case 'max'
						x = -obj.fmap(profile);
					end
					
				case 'double'
				x = obj.weight.*(obj.fmap(profile) - obj.prediction).^2;
			end
			
			x = sum(x);
		end
	end
end
