function cell = struct2cell(s)
list	= fieldnames(s);
value	= struct2cell(s); % this calls matlab's native function
n		= numel(list);

cell			= {};
cell(1:2:2*n-1) = list;
cell(2:2:2*n)	= value;