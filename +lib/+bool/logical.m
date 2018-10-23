function b = logical(obj)
switch class(obj)
	case 'logical'
		b = obj;
		
	case 'double'
		b = logical(obj);
	
	case 'char'
		switch obj
			case {'on','true','yes','y'}
				b = logical(1);
			
			case {'off','false','no','n'}
				b = logical(0);
		end
end