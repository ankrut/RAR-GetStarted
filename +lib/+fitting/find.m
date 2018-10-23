function [SOL,varargout] = find(varargin)
Q = lib.ecma.struct(...
	'tau',		1E-6,...
	varargin{:}...
); 

% destructure
vm			= Q.model;
list		= parseQuery(Q);
fSolution	= parseSolutionHandle(Q);

% init loop
nn			= numel(fSolution);
chi2(1:nn)	= nan;

for ii = 1:nn
	if isnan(min(chi2)) || min(chi2) > Q.tau
		try
			[SOL(ii),VM(ii)] = fSolution{ii}(vm,list);
			chi2(ii)		 = list.chi2(SOL(ii));
		catch
			fprintf('\n');
		end
	end
end

if isnan(min(chi2))
	error('no solution found')
end

% select best solution
kk				= chi2 == min(chi2);
SOL				= SOL(kk);
varargout{1}	= VM(kk);
varargout{2}	= chi2(kk);


function fSolution = parseSolutionHandle(Q)
switch class(Q.fSolution)
	case 'function_handle'
	fSolution{1} = Q.fSolution;
		
	case 'cell'
	fSolution = Q.fSolution;
		
	otherwise
	error('unknown fSolution type');	
end

function list = parseQuery(Q)
switch class(Q.query)
	case 'cell'
	q	 = lib.ecma.struct(Q.query{:});
	list = convertQueryToResponselist(q,Q.ResponseList);
	
	case 'struct'
	q	 = Q.query;
	list = convertQueryToResponselist(q,Q.ResponseList);
	
	case 'lib.profile.response'
	list = lib.profile.responseList(Q.query);
	
	case 'lib.profile.responseList'
	list = Q.query;
	
	otherwise
	error('unknown query type');
end

function list = convertQueryToResponselist(q,ResponseList)
list = lib.ecma.array(fieldnames(q)).map(@(key) ...
	createResponse(ResponseList.(key),q.(key)) ...
).pipe(@lib.profile.responseList);

function elm = createResponse(response, prediction)
if numel(prediction) == 1
	elm = lib.profile.response('map', response, 'prediction', prediction);
else
	elm = lib.profile.response('map', response(prediction(1:end-1)), 'prediction',prediction(end));
end