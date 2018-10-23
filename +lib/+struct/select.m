function s = select(varargin)
Q = lib.ecma.struct(varargin{:});
s = struct();

for ii=1:numel(Q.id);
	s.(Q.id{ii}) = Q.struct.(Q.id{ii});
end
