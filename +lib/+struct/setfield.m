function s=setfield(s,varargin)
for ii=1:2:nargin-1
	path	= varargin{ii};
	value	= varargin{ii+1};
	
	fields	= strsplit(path,'/');
	s		= setfield(s,fields{:},value);
end
	