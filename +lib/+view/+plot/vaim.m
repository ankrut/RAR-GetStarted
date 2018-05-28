function vaim(x,y,varargin)
lib.view.plot.vline(x,'Color', [1 1 1]*0.7, 'LineStyle',':',varargin{:});
plot(x,y,'Marker','o', 'MarkerFaceColor', 'w', 'MarkerEdgeColor','w','MarkerSize',10);