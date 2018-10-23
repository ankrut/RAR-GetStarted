classdef mapping < handle
	properties
		fmap		% function_handle or double
		label		% label of mapping (e.g. '\theta_0')
	end
	
	methods
		function obj=mapping(varargin)
			Q = lib.ecma.struct(...
				'label',	'undefined',...
				varargin{:} ...
			);
		
			switch class(Q.map)
				case 'function_handle'
				obj.fmap = Q.map;
				
				case 'double'
				obj.fmap = @(obj) Q.map;
				
				otherwise
				error('undefined map argument');
			end
			
			obj.label = Q.label;
		end
		
		function x = map(obj,varargin)
			Q = lib.ecma.struct(...
				varargin{:}...
			);
			
			if isfield(Q,'anchor')
				x = Q.anchor.map('data', Q.data, 'y', obj);
			else
				x = obj.fmap(Q.data);
			end
		end
	end
end