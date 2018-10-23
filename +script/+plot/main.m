function main
% load cached data, render and figure
STORE	= load('+script/+calc/STORE.mat');
RENDER	= lib.ecma.require(@script.plot.render);
FIG		= lib.ecma.require(@script.plot.figure);

% show figure
figure(FIG);

% show solutions
STORE.profiles.forEach(RENDER.radiusVsVelocity);

% show legend
lib.view.plot.legend([],'location','northeast');

% save figure (pdf)
saveas(FIG, '+script/+plot/figure.pdf');
