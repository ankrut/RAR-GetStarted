function scales
% load packages
CONST	= lib.ecma.require(@lib.physics.constants);

% calc test solution
vm		= struct('m', 48*CONST.keVcc, 'beta0', 1E-6, 'theta0', 30, 'W0', 66);
p		= lib.model.cRAR.profile('model', vm);

% set scale packages
TBL.raw		= lib.ecma.require(@lib.model.cRAR.scale.raw);
TBL.SI		= lib.ecma.require(@lib.model.cRAR.scale.SI);
TBL.astro	= lib.ecma.require(@lib.model.cRAR.scale.astro);
TBL.cgs		= lib.ecma.require(@lib.model.cRAR.scale.cgs);
TBL.natural = lib.ecma.require(@lib.model.cRAR.scale.natural);
TBL.center	= lib.ecma.require(@lib.model.cRAR.scale.center);
TBL.core	= lib.ecma.require(@lib.model.cRAR.scale.core);
TBL.plateau = lib.ecma.require(@lib.model.cRAR.scale.plateau);
TBL.halo	= lib.ecma.require(@lib.model.cRAR.scale.halo);
TBL.surface = lib.ecma.require(@lib.model.cRAR.scale.surface);

% check each packages
key = fieldnames(TBL);
for jj = 1:numel(key)
	SCALE = TBL.(key{jj});
	list = fieldnames(SCALE);
	for ii = 1:numel(list)
		try
			SCALE.(list{ii}).map('data', p);
			fprintf('[%s] %s.%s\n','  ok  ',key{jj},list{ii});
		catch
			fprintf(2,'[%s]%s.%s\n','FAILED',key{jj},list{ii});
		end
	end
end