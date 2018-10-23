function performance(varargin)
vm = struct('beta0', 1E-6, 'theta0', 30, 'W0', 66);

Q = lib.ecma.struct(...
	'imax',		10,...
	'model',	vm,...
	varargin{:} ...
);


tt = zeros(1,Q.imax);
for ii=1:Q.imax
	tic
	lib.model.cRAR.profile('model', Q.model);
	tt(ii) = toc;
	
	fprintf('[%d] %4.3fs\n',ii,tt(ii));
end

fprintf('total (%d): %5.3fs\n',ii,sum(tt));
fprintf('mean: %5.3fs\n',sum(tt)/ii);