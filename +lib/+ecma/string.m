classdef string < handle
	properties
		value
	end
	
	methods
		function obj = string(val)
			obj.value = val;
		end
		
		function obj = escape(obj)
			obj.value = regexprep(obj.value,'(\\)','\\$1');
		end
	end
end
	