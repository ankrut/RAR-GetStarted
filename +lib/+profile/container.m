classdef container < handle
	properties
		data
	end
    
    methods
		% constructor
		function obj = container()
			obj.data = struct();
		end
		
		% add/set new data (static)
		function obj = set(obj,key,data)
			if isa(data,'function_handle')
				obj.data.(key) = data(obj);
			else
				obj.data.(key) = data;
			end
		end
		
		function data = get(obj,key)
			data = obj.data.(key);
		end
		
		function p = copy(obj,varargin)
			ch = str2func(class(obj));
			p = ch(varargin{:});
			
			p.data = obj.data;
		end
		
		function obj = load(obj,filename)
			T	 = load(filename);
			list = fieldnames(T);
			
			lib.ecma.array(list).forEach(@(key) ...
				obj.set(key,T.(key))...
			);
		end
		
		function obj = save(obj,filename)
			lib.view.file.mat(filename,obj.data);
		end
	end
end