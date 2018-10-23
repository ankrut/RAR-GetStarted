classdef responseList < lib.ecma.array
	methods
		function obj = responseList(varargin)
			obj = obj@lib.ecma.array(varargin{:});
		end
		
		function value=chi2(obj,profile)
			fCHI2 = @(elm) elm.chi2(profile);
			value = sum(obj.stream(fCHI2));
		end
	end
end