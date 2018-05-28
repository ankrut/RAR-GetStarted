function varargout = pipe(s,func)
cell = lib.struct.toCell(s);
[varargout{1:nargout}] = func(cell{:});
