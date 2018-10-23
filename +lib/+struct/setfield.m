function s=setfield(s,varargin)
if(numel(varargin) == 1)
	T = varargin{1};
	
	switch(class(T))
		case 'lib.ecma.array'
			for ii = 1:T.length
				fields	= strsplit(T.data{ii}.path(:)','/');
				s		= setfield(s,fields{:},T.data{ii}.value);
			end
	end
else
	for ii=1:2:nargin-1
		path	= varargin{ii};
		value	= varargin{ii+1};

		fields	= strsplit(path,'/');
		s		= setfield(s,fields{:},value);
	end
end
	