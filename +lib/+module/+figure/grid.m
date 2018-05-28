function fh=grid(ax,varargin)
% default values (in points)
WIDTH		= 420;
HEIGHT		= 315;
PADDING		= struct('top', 10, 'left', 45, 'right', 10, 'bottom', 40);

Q = lib.module.struct(...
	'width',		WIDTH,...
	'height',		HEIGHT,...
	'padding',		PADDING,...
	'units',		'points',...
	'showLabels',	'auto',...
	'XGridWeight',	ones(size(ax,2),1),...
	'YGridWeight',	ones(size(ax,1),1),...
	'figure',		{},...
	varargin{:}...
);

% destructure
WIDTH		= Q.width;
HEIGHT		= Q.height;
PADDING		= Q.padding;

if isfield(Q,'paddingTop')
	PADDING.top = Q.paddingTop;
end

if isfield(Q,'paddingBottom')
	PADDING.bottom = Q.paddingBottom;
end

if isfield(Q,'paddingLeft')
	PADDING.left = Q.paddingLeft;
end

if isfield(Q,'paddingRight')
	PADDING.right = Q.paddingRight;
end

try
	switch class(Q.axWidth)
	case 'double'
		AXWIDTH = Q.axWidth;
		
		otherwise
		error('wrong axWidth type');
	end
	
	WIDTH = AXWIDTH*size(ax,2) + PADDING.left + PADDING.right;
catch
	AXWIDTH = (WIDTH - PADDING.left - PADDING.right)/size(ax,2);
end


try	
	switch class(Q.axHeight)
		case 'double'
		AXHEIGHT = Q.axHeight;
		
		case 'function_handle'
		AXHEIGHT = Q.axHeight(AXWIDTH);
		
		case 'char'
		switch Q.axHeight
			case 'equal'
			AXHEIGHT = AXWIDTH;
			
			otherwise
			error('axHeight keyword not defined');
		end
		
		otherwise
		error('wrong axHeight type');
	end
	
	HEIGHT = AXHEIGHT*size(ax,1) + PADDING.top + PADDING.bottom;
catch
	AXHEIGHT = (HEIGHT - PADDING.top - PADDING.bottom)/size(ax,1);
end

switch class(Q.XGridWeight)
	case 'double'
	XGRIDWEIGHT = Q.XGridWeight;

	otherwise
	error('unknown XGridWeight type');
end

switch class(Q.YGridWeight)
	case 'double'
	YGRIDWEIGHT = Q.YGridWeight;

	otherwise
	error('unknown YGridWeight type');
end



DIM = struct(...
	'width',	WIDTH,...
	'height',	HEIGHT,...
	'padding',	PADDING,...
	'grid',		size(ax) ...
);

% normalize grid weights
XGRIDWEIGHT = DIM.grid(2)*XGRIDWEIGHT./sum(XGRIDWEIGHT);
YGRIDWEIGHT = DIM.grid(1)*YGRIDWEIGHT./sum(YGRIDWEIGHT);

X0(1) = DIM.padding.left;
for ii = 1:size(ax,2)
	X0(ii+1) = X0(ii) + AXWIDTH*XGRIDWEIGHT(ii);
end

Y0(1) = HEIGHT - DIM.padding.top - AXHEIGHT*YGRIDWEIGHT(1);
for ii = 1:size(ax,1)
	Y0(ii+1) = Y0(ii) - AXHEIGHT*YGRIDWEIGHT(ii);
end

fAxisPosition = @(ii,jj) [
	X0(ii)
	Y0(jj)
	AXWIDTH*XGRIDWEIGHT(ii)
	AXHEIGHT*YGRIDWEIGHT(jj)
];


fh = figure(...
	'Visible',					'off',...
	'defaulttextinterpreter',	'latex',...
	'Units',					Q.units,...
	'PaperUnits',				Q.units,...
	'PaperSize',				[DIM.width DIM.height],...
	'PaperPosition',			[0,0,DIM.width,DIM.height],...
	Q.figure{:}...
);

fh.Position(2) = fh.Position(2) - (DIM.height - fh.Position(4));
fh.Position(3) = DIM.width;
fh.Position(4) = DIM.height;

% hide ticks and labels
if strcmp(Q.showLabels, 'auto')
	set(ax(1:size(ax,1)-1,:),'XTickLabel',[]);
	set(ax(1:size(ax,1)-1,:),'XLabel',[]);
	set(ax(:,2:size(ax,2)),'YTickLabel',[]);
	set(ax(:,2:size(ax,2)),'YLabel',[]);
end

for ii = 1:size(ax,2)
for jj = 1:size(ax,1)
	if isa(ax(jj,ii),'matlab.graphics.GraphicsPlaceholder')
		continue
	end
	
	set(ax(jj,ii),...
		'Parent',			fh,...
		'Units',			Q.units,...
		'Position',			fAxisPosition(ii,jj) ...
	);
end
end