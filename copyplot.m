


function [source,destination,C]=copyplot(varargin)
%|
%| function  [source,destination,C]=copyplot(varargin)
%|====================================================================================
%| COPYPLOT copies all graphic objects identified by 'source' in a graphic holder 
%| identified by 'destination'.
%| Also the legend will be copied. 
%|
%|-------------------------------------------------------------------------------------
%|  INPUTS:
%| 	  varargin
%| 		  varargin must be a combination of 3 parameters: <[char] input, [char] type, 
%|        [double] value>.
%|
%|        Varargin syntax:
%|
%| 			  ...,[char] input , [char] type , [double] value,...
%|
%|		  where:
%| 			
%| 			input    [char]    'source'/'destination'
%| 				'source'      --> type and value will identify the objects that will 
%|                                be copied.
%| 				'destination' --> type and value will identify the destination in which 
%|                                source objects will be copied.
%|                                 NOTE: if destination figure does not exist, it will
%|                                       be automatically created.
%|
%| 			type     [char]    'figure'/'subplot'
%| 				'figure'      --> value will refer to a whole figure
%|              'axes'        --> value will refer to a specific axes (valid only for 
%|                                "source" input)
%| 				'subplot'     --> value will identify a subplot
%| 				
%| 			value    [double] or [graphic object] (valid only for "source" input)
%|              if value is [double]
%| 				  if type is 'figure'
%| 							  --> figure number
%| 				  if type is 'subplot'
%| 							  --> array [FigureNumber SubplotRows SubplotCol SubplotID]
%|
%| 			    if value is [graphic object]:
%| 				  if type is 'axes' 
%| 							  --> axes object
%| 
%|-------------------------------------------------------------------------------------
%|  OUTPUTS:
%|	 source         [Graphics]    list of objects taken as source
%|   destination    [Axes]        axes taken as destination
%|   C              [Graphics]    list of new objects (copy of source)
%|
%|=====================================================================================
%|  EXAMPLES:  
%| 	  Copy figure 5 (only one axes) to figure 4 that has a 3x2 subplot in subplotID 1 
%|    ( subplot(3,2,1) ):
%|
%|      copyplot( 'source','figure', 5, 'destination', 'subplot', [4 3 2 1] );
%|
%|_____________________________________________________________________________________
%|Author: ni-il
%\_____________________________________________________________________________________
	
	
%=============================================================================
% INPUTS
%
	source=[];
	destination=[];
	
	for j=1:3:length(varargin)
		input=varargin{j};
		type=varargin{j+1};
		value=varargin{j+2};
		
		% type: figure
		if strcmp(lower(type),'figure')
			F=figure(value);
			ax=gca;
			ch=ax.Children;
		end
		
		% type: axes (only for "source")
		if strcmp(lower(type),'axes')
			ax= value;
			ch= ax.Children;
			F= find_figure_of(ax);		
		end 
		
		% type: subplot
		if strcmp(lower(type),'subplot')
			if ~length(value)==4
				error('value must have size 4 ([figN sbplNRows sbpltNCol sbpltID]')
            else
                F=figure(value(1));
                ax=subplot(value(2),value(3),value(4));
                ch=ax.Children;
            end
        end
		% input: source
		if strcmp(lower(input),'source')
			source_ch =ch;
			source_ax =ax;
			source_F  =F;
		end
		% input: destination
		if strcmp(lower(input),'destination')
			destination_F = F;
			destination_ax = ax;
			if isempty(F)
				error('Destination figure not specified.')
			end
			if isempty(ax)
				error('Destination axes not specified.')
			end	
			
			if strcmp(lower(type),'subplot')
				destination_is_subplot_ax=1;
			else
				destination_is_subplot_ax=0;
			end
		end
	end% varargin
	
	%------------------------------
	% Switch source/destination:
	%  subplot destination
	if destination_is_subplot_ax
		source = source_ch;
		destination = destination_ax;
	else
		source = source_ax;
		Fnum=destination_F.Number;
		close(destination_F);
		destination_F=figure(Fnum);
		destination=destination_F;
	end
	
	if isempty(source)
		%error('Source not provided')
		warning('Source not provided. COPY FAILED.')
		return
	end
	
	if isempty(destination)
		%error('Destination not provided');
		warning('Destination not provided. COPY FAILED.');
		return
	end
	
	
%=============================================================================
% COPY
%
	errorsoccurred=0;
	
	C=copyobj(source,destination);
		
	if destination_is_subplot_ax
			
		%%%% To have a look of all properties of an axes
		%%%
		%%%	    fieldnames(gca)
		%%%	  
			
		source_ax_XLabel =source_ax.XLabel;
		source_ax_YLabel =source_ax.YLabel;
		source_ax_ZLabel =source_ax.ZLabel;
		source_ax_Title  =source_ax.Title;
		
		
			
		copyobj(source_ax_XLabel , destination);
		copyobj(source_ax_YLabel , destination);
		copyobj(source_ax_ZLabel , destination);
		
		% TITLE
		prop= properties( source_ax_Title );
		destination_ax_Title= title(destination_ax,'');
		for j=1:length(prop)
			if ~any(strcmp( prop{j}, {'Position', 'FontSize',   'Parent', 'Children',   'BeingDeleted', 'Extent', 'Type'} )) %'BeingDeleted', 'Extent', 'Type' :: read-only properties
				try
					set(destination_ax_Title, prop{j}, get(source_ax_Title, prop{j}) );
					%fprintf('OK   : %s\n',pad(prop{j},20,'left','.'));
				catch ME
					fprintf('ERROR: %s -> %s\n',pad(prop{j},20,'left','.'),ME.message);
				end
			end
		end
		set(destination_ax_Title, 'FontSize', get(source_ax_Title, 'FontSize') );	
		
		
		%###copyobj(source_ax_Legend , destination); CAN'T COPY LEGEND
		%WITHOUT COPYING ASSOCIATED AXES.
		
		XLIM       =source_ax.XLim;
		YLIM       =source_ax.YLim;
		ZLIM       =source_ax.ZLim;
		XTICK      =source_ax.XTick;
		YTICK      =source_ax.YTick;
		ZTICK      =source_ax.ZTick;
		XTICKminor =source_ax.XMinorTick;
		YTICKminor =source_ax.YMinorTick;
		ZTICKminor =source_ax.ZMinorTick;
		
		destination.XLim       = XLIM      ;
		destination.YLim       = YLIM      ;
		destination.ZLim       = ZLIM      ;
		destination.XTick      = XTICK     ;
		destination.YTick      = YTICK     ;
		destination.ZTick      = ZTICK     ;
		destination.XMinorTick = XTICKminor;
		destination.YMinorTick = YTICKminor;
		destination.ZMinorTick = ZTICKminor;
		
			
		propertiestocopy={
			'GridColor'
			'GridColorMode'
			'MinorGridColor'
			'MinorGridColorMode'
			'GridAlpha'
			'GridAlphaMode'
			'MinorGridAlpha'
			'MinorGridAlphaMode'
			'NextPlot'
			'Box'
			'Visible'
			'HandleVisibility'
			'Box'
			'BoxStyle'
			'LineWidth'
			'FontName'
			'FontAngle'
			'FontWeight'
			'FontSmoothing'
			'FontUnits'
			'FontSize' 
			'XGrid'
			'YGrid'
			'ZGrid'
			'XMinorGrid'
			'YMinorGrid'
			'ZMinorGrid'};
		
		for fn = propertiestocopy'
			%disp(fn{1})
			p = source_ax.(fn{1});
			try 
				set( destination , (fn{1}) , p );
			catch ME
				errorsoccurred=1;
				warningmsg=[': ',ME.message];
				fprintf('#### Warning: copying property <%s> : %s\n',fn{1},warningmsg)
			end
		end
	else
		figure(Fnum);
		destination_ax=gca;
		
	end%if destination_is_subplot_ax
	
	% COPY COLORMAP
	%set( destination_F, 'Colormap', get(source_F,'Colormap'));
	source_cmap = colormap(source_ax);
	destination_cmap = colormap(destination_ax, source_cmap);
	set( destination_ax, 'CLim',     get( source_ax, 'CLim'     ) );
	set( destination_ax, 'CLimMode', get( source_ax, 'CLimMode' ) );
	
	%%%% COPY AXIS
	%%% set( destination_ax, 'XAxis',   get(source_ax,'XAxis') );
	%%% set( destination_ax, 'YAxis',   get(source_ax,'YAxis') );
	%%% set( destination_ax, 'ZAxis',   get(source_ax,'ZAxis') );
	%%% \___ERROR: Trying to reparent an already connected internal component object.
	
	
	%------------------------------------------------------------------------------------
	% COPY LEGEND
	source_ax_Legend =source_ax.Legend;
	if ~isempty(source_ax_Legend) %&& isfield(source_ax_Legend,'String')
		try
			destination_ax_Legend = legend(destination_ax,source_ax_Legend.String);
		catch ME
			errorsoccurred=1;
			warningmsg=[': ',ME.message];
			fprintf('#### Warning: copying legend : %s\n',warningmsg)
		end
		% legend properties to copy
		lp2c = {
			'Box'
			'Color'
			'EdgeColor'
			'FontName'
			'FontSize'
			'FontAngle'
			'FontWeight'
			'Interpreter'
			'LineWidth'
			'Location'
			'Orientation'
			'Position'
			'TextColor'
			'Units'
			'Visible'
			};
	
		for j=1:size(lp2c,1)
			p = source_ax_Legend.(lp2c{j});
			try
				set( destination_ax_Legend , (lp2c{j}) , p );
			catch ME
				errorsoccurred=1;
				warningmsg=[': ',ME.message];
				fprintf('#### Warning: copying legend property <%s> : %s\n',lp2c{j},warningmsg)
			end
		end
	end
	
	if errorsoccurred
		warning('Some error occurred.')
	end
	
end






function fig = find_figure_of(ax)
	
	obj=ax;
	err=false;
	nmax=100;
	it=1;
	while it<nmax
		if any( strcmp( lower(properties(obj)) , 'parent' ) )
			P = get( obj, 'parent' );
			if any( strcmp( lower(properties(P)) , 'type' ) )
				Ptype = get( P, 'type' );
				if strcmp(Ptype, 'figure')
					fig=P;
					break
				else
					obj=P;
				end
			else
				err=true;
			end
		else
			err=true;
		end
		if err
			error('Can''t find given axes'' parent figure.')
		end
		it=it+1;
	end
end
			
	
	
	
	
%END