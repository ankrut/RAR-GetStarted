function str=sprintf(formatSpec,varargin)
str = sprintf(lib.escape(formatSpec),varargin{:});