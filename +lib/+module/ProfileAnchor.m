classdef ProfileAnchor < handle
	properties
		fmap
		fanchor
	end
	
	methods
		function obj=ProfileAnchor(fmap,fanchor)
			obj.fmap	= fmap;
			obj.fanchor = fanchor;
		end
		
		% varargin		[lib.module.ProfileAxis]
		function [varargout] = map(obj,profile,varargin)
			% get anchor point (x-value)
			X		= obj.fmap(profile);
			PNT		= obj.fanchor(profile,X);

			% preallocate
			varargout = cell(size(varargin));
			
			% collect other values (y-values)
			for ii=1:length(varargin)
				switch class(varargin{ii})
					case 'char'
					ykey = varargin{ii};
					Y = profile.data.(ykey);
				
					case {'lib.module.ProfileAxis','lib.module.ProfileMapping'}
					Y = varargin{ii}.map(profile);
				
					otherwise
					Y = varargin{ii};
				end
				
				varargout{ii} = interp1(X,Y,PNT,'spline');
			end
		end
	end
end