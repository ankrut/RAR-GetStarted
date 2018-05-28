function value=getfield(s,path)
fields = strsplit(path,'/');
value = getfield(s,fields{:});