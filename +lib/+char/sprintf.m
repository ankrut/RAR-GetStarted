function str=sprintf(formatSpec,varargin)
str = sprintf(lib.char.escape(formatSpec),varargin{:});