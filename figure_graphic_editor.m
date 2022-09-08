


function figure_graphic_editor(varargin)
%|
%| function  figure_graphic_editor(varargin)
%|=====================================================================================
%| FIGURE_GRAPHIC_EDITOR modifies figure properties.
%|
%|-------------------------------------------------------------------------------------
%|  INPUTS:
%| 	  varargin
%|        varargin must be given as couple of <[char] input_name, [ ] input_value>.
%|        Input name must be [char].
%|
%|        Varargin syntax:
%|
%|	        ...,[char] input_name  ,[ ] input_value,...
%|        
%|
%|             INPUT_NAME     INPUT_VALUE
%|
%|             fig / figure
%|                            [double] figure number
%|                            [char]   all
%|	        				  ** NOTE: if not specified, function will act 
%|                                     on current figure only
%|          
%|             p   / preset
%|                            [double] preset number
%|          
%|             legpos
%|                            [char]   legend position (east, north, ...)
%|                            [char]   donttouch
%|          
%|             ms  / markersize 
%|                            [double] value
%|          
%|             lw  / linewidth 
%|                            [double] value
%|          
%|             fs  / fontsize 
%|                            [double] value
%|          
%|             makefullscreen 
%|                            [char]   yes / no / restore
%|                            ** NOTE: 'restore' will resize the figure to the
%|                                     default creation value.
%|          
%|             xlim
%|                            [double] 1x2 ([botlim toplim])
%|          
%|             ylim
%|                            [double] 1x2 ([botlim toplim])
%|          
%|             zlim
%|                            [double] 1x2 ([botlim toplim])
%|          
%|             xtick
%|                            [double] 1xN ([tick1 ... tickN])
%|          
%|             ytick
%|                            [double] 1xN ([tick1 ... tickN])
%|          
%|             ztick
%|                            [double] 1xN ([tick1 ... tickN])
%|          
%|	           xlabel
%|                            [char] label of x-axis
%|          
%|	           ylabel
%|                            [char] label of y-axis
%|          
%|	           zlabel
%|                            [char] label of z-axis
%|          
%|	           title
%|                            [char] axes title string
%|          
%|	           grid
%|                            [char] 'on'/'off'
%|          
%|	           colorbar
%|                            [char] 'on'/'off'
%|          
%|             view
%|                            [double] 1x2 ([AZ EL]) or 1x3 ([X Y Z])
%|
%|
%|
%|	Unknown varargin input:
%|
%|	   "unknownparam"
%|                     'unknownparam' refers to an input that is currently
%|                     not implemented in this function.
%|                     This funciton will try to acces this property and set
%|                     the specified value.
%|                     ** NOTE: 'unknownparam' may refer to a figure property, an axes
%|                              property or a specific graphical  objcet's property.
%|                              If not specified, this function will try to set 
%|                              "unknownparam" either to the figure and to its children.
%|                              
%|                              To specify target graphical object:
%|                              'unknownparam_f' will refer to figure
%|                              'unknownparam_a' will refer to axes
%|                              'unknownparam_@' will refer to a specific graphic
%|                                    |           object which type has to be specified
%|                                    |           in value input field with this 
%|                                    |           specific syntax:
%|                                    V          
%|                                  value = {[char] 'type', [all] value}
%|
%|                                    example: ...,'BarWidth_@',{'Bar',1.2},...
%|
%|=====================================================================================
%|  EXAMPLES:
%|    figure_graphic_editor('ms',2)
%|    figure_graphic_editor('lw',1,'ms',10')
%|    figure_graphic_editor('EdgeAlpha_@',{'patch',0.5})
%|    figure_graphic_editor('fontsize',26,'makefullscreen','yes')
%|    figure_graphic_editor('figure','all','BackgroundColor_@',{'uitab','w'}
%|    figure_graphic_editor('figure','all','color_a','k','grid','on', ...
%|                          'GridColor_a','w', ...
%|                          'GridAlpha_a',0.5,'fs',22, ...                            
%|                          'BackgroundColor_@',{'uitab', '[0 0 0]}, ...
%|                          'Color_@',{'XAxis','w'},'Color_@',{'YAxis','w'})
%|
%|=====================================================================================
%|Author: ni-il
%\_____________________________________________________________________________________


%=================================================
% MATLAB DEFAULT COLORS
%
%   c1=[0,      0.4470, 0.7410]; % blu mare
%   c2=[0.8500, 0.3250, 0.0980]; % rosso arancio
%   c3=[0.9290, 0.6940, 0.1250]; % giallo senape
%   c4=[0.4940, 0.1840, 0.5560]; % viola porpora
%   c5=[0.4660, 0.6740, 0.1880]; % verde prato chiaro
%   c6=[0.3010, 0.7450, 0.9330]; % celeste cielo
%   c7=[0.6350, 0.0780, 0.1840]; % rosso rubino	
	
	makechanges = true;
	
	figNvect = gcf;
	preset_defined   = false;
	figNvect_defined = false;
	preset_defined   = false;
	legpos_defined   = false;
	mrksize_defined  = false;
	lnwdth_defined   = false;
	fontsize_defined = false;
	fontname_defined = false;
	mkfllscr_defined = false;
	xlim_defined     = false;
	ylim_defined     = false;
	zlim_defined     = false;
	xtick_defined    = false;
	ytick_defined    = false;
	ztick_defined    = false;
	xlabel_defined   = false;
	ylabel_defined   = false;
	zlabel_defined   = false;
	title_defined    = false;
	grid_defined     = false;
	colorbar_defined = false;
	view_defined     = false;
	
	modify_fontname = 0;
	modify_fontsize = 0;
	modify_lnwdth  = 0;
	modify_mrksize = 0;
	
	FontSize          = []; %default=10
	FontSize_TextBox  = []; %default=10
	FontName          = []; %default=Helvetica
	LineWidth         = []; %default=0.5
	LineWidth_TextBox = []; %default=0.5
	MarkerSize        = []; %default=6
	
	
	%implemented
	known_inputs={'figure','fig',...
		          'preset','p',...
		          'legpos',...
		          'markersize','ms',...
		          'linewidth','lw',...
		          'fontsize','fs',...
		          'fontname',...
		          'makefullscreen',...
		          'xlim',...
		          'ylim',...
		          'zlim',...
		          'xtick',...
		          'ytick',...
		          'ztick',...
				  'xlabel'...
				  'ylabel',...
				  'zlabel',...
				  'title',...
				  'grid',...
				  'colorbar',...
				  'view'};
	%counters for unkonwn parameters
	nunk=0; 
	nunkf=0;
	nunka=0;
	nunks=0;
	nunku=0;
	
	
	
	Nvar = length(varargin);
	for j=1:2:Nvar-1
		
		if ~ischar(varargin{j})
			errormsg=['In input number: ',num2str(j),'. ERROR: Input names must be [char].'];
			error(errormsg)
		end
		
		%% figure
		if strcmp(lower(varargin{j}),lower('fig')) || strcmp(lower(varargin{j}),lower('figure')) 
			figNvect = varargin{j+1};
			figNvect_defined = true;
			if ischar(figNvect)&&strcmp(lower(figNvect),'all')
				figNvect=findobj('Type','figure');
			end
			
		%% preset
		elseif strcmp(lower(varargin{j}),lower('preset')) || strcmp(lower(varargin{j}),lower('p'))
			PRESET = varargin{j+1};
			if ischar(PRESET)
				error('PRESET must be [double] and integer. Available presets are 0, 1, 2, 3.')
			end
			preset_defined = true;
			
		%% legpos
		elseif strcmp(lower(varargin{j}),lower('legpos'))
			legpos = varargin{j+1};
			legpos_defined = true;
			
		%% markersize
		elseif strcmp(lower(varargin{j}),lower('markersize')) || strcmp(lower(varargin{j}),lower('ms'))
			mrksize = varargin{j+1};
			mrksize_defined = true;
			
		%% linewidth
		elseif strcmp(lower(varargin{j}),lower('linewidth')) || strcmp(lower(varargin{j}),lower('lw'))
			lnwdth = varargin{j+1};
			lnwdth_defined = true;
		
		%% fontsize
		elseif strcmp(lower(varargin{j}),lower('fontsize')) || strcmp(lower(varargin{j}),lower('fs'))
			fontsize = varargin{j+1};
			fontsize_defined = true;
		
		%% fontname
		elseif strcmp(lower(varargin{j}),lower('fontname'))
			fontname = varargin{j+1};
			if ~ischar(fontname)
				error('FONTNAME must be [char].');
			end
			fontname_defined = true;
		
		%% makefullscreen
		elseif strcmp(lower(varargin{j}),lower('makefullscreen'))
			mkfllscr = varargin{j+1};
			mkfllscr_defined = true;
		
		%% xlim
		elseif strcmp(lower(varargin{j}),lower('xlim'))
			xlim = varargin{j+1};
			if ~size(xlim)==[1 2]
				error('xlim argument must be [double] 1x2 ([botlim toplim])');
			end
			xlim_defined = true;
			
		%% ylim
		elseif strcmp(lower(varargin{j}),lower('ylim'))
			ylim = varargin{j+1};
			if ~size(ylim)==[1 2]
				error('ylim argument must be [double] 1x2 ([botlim toplim])');
			end
			ylim_defined = true;
		
		%% zlim
		elseif strcmp(lower(varargin{j}),lower('zlim'))
			zlim = varargin{j+1};
			if ~size(zlim)==[1 2]
				error('zlim argument must be [double] 1x2 ([botlim toplim])');
			end
			zlim_defined = true;
		
		%% xtick
		elseif strcmp(lower(varargin{j}),lower('xtick'))
			xtick = varargin{j+1};
			if ~length(xtick)>1
				error('xtick argument must be [double] 1xN ([tick1 ... tickN])');
			end
			xtick_defined = true;
		
		%% ytick
		elseif strcmp(lower(varargin{j}),lower('ytick'))
			ytick = varargin{j+1};
			if ~length(ytick)>1
				error('ytick argument must be [double] 1xN ([tick1 ... tickN])');
			end
			ytick_defined = true;
		
		%% ztick
		elseif strcmp(lower(varargin{j}),lower('ztick'))
			ztick = varargin{j+1};
			if ~length(ztick)>1
				error('ztick argument must be [double] 1xN ([tick1 ... tickN])');
			end
			ztick_defined = true;
		
		%% xlabel
		elseif strcmp(lower(varargin{j}),lower('xlabel'))
			labelx = varargin{j+1};
			if ~ischar(labelx)
				error('XLabel argument must be [char]');
			end
			xlabel_defined = true;
			
		%% ylabel
		elseif strcmp(lower(varargin{j}),lower('ylabel'))
			labely = varargin{j+1};
			if ~ischar(labely)
				error('YLabel argument must be [char]');
			end
			ylabel_defined = true;
			
		%% zlabel
		elseif strcmp(lower(varargin{j}),lower('zlabel'))
			labelz = varargin{j+1};
			if ~ischar(labelz)
				error('ZLabel argument must be [char]');
			end
			zlabel_defined = true;
			
		%% title
		elseif strcmp(lower(varargin{j}),lower('title'))
			titlestring = varargin{j+1};
			if ~ischar(titlestring)
				error('Title argument must be [char]');
			end
			title_defined = true;
		
		%% grid
		elseif strcmp(lower(varargin{j}),lower('grid'))
			gridval = varargin{j+1};
			if ~ischar(gridval)
				error('Grid argument must be [char] ''on''=/''off''');
				if ~( strcmp(gridval,'on') || strcmp(gridval,'off') )
					error('Grid argument must be [char] ''on''=/''off''');
				end
			end
			grid_defined = true;
		
		%% colorbar
		elseif strcmp(lower(varargin{j}),lower('colorbar'))
			cbarval = varargin{j+1};
			if ~ischar(cbarval)
				error('ColorBar argument must be [char] ''on''=/''off''');
				if ~( strcmp(cbarval,'on') || strcmp(cbarval,'off') )
					error('Grid argument must be [char] ''on''=/''off''');
				end
			end
			colorbar_defined = true;
		
		%% view
		elseif strcmp(lower(varargin{j}),lower('view'))
			viewval = varargin{j+1};
			viewval
			if ~isnumeric(viewval) || ~( all(size(viewval)==[1 2]) || all(size(viewval)==[1 3]) )
				error('View argument must be [double] 1x2 ([AZ EL]) or 1x3 ([X Y Z])');
			end
			view_defined = true;
		
		%% unrecognized input
		else
			warningmsg=['Unrecognized input:  ',varargin{j},'. Input functionality not guaranteed.'];
			warning(warningmsg)
			nunk = nunk+1;
			inp=varargin{j};
			if strcmp( lower(inp(end-1:end)) , '_f' ) % input refers to figure properties
				nunkf=nunkf+1;
				if any( strcmp(lower(inp(1:end-2)) , known_inputs) )
					fprintf('WARNING: input  "%s"  is implemented in this function.\n  It is more convenient to use the standard implementation.\n',inp(1:end-2))
				end
			elseif strcmp( lower(inp(end-1:end)) , '_a' ) % input refers to axes properties
				nunka=nunka+1;
				if any( strcmp(lower(inp(1:end-2)) , known_inputs) )
					fprintf('WARNING: input  "%s"  is implemented in this function.\n  It is more convenient to use the standard implementation.\n',inp(1:end-2))
				end
			elseif strcmp( lower(inp(end-1:end)) , '_@' ) % input refers to specific graphic object
				nunks=nunks+1;
				if any( strcmp(lower(inp(1:end-2)) , known_inputs) )
					fprintf('WARNING: input  "%s"  is implemented in this function.\n  It is more convenient to use the standard implementation.\n',inp(1:end-2))
				end
			else % input reference is not specified -> unspecified
				nunku=nunku+1;
			end
		end
	end
	%% store unrecognized parameters
	if nunk~=0
		UNKF=cell(nunkf,2); %figure
		UNKA=cell(nunka,2); %axes
		UNKS=cell(nunks,3); %specified value
		UNKU=cell(nunku,2); %unspecified
		UNKS_logic=false(nunks,1); %logic array that is true if input j has been tried to be enforced 
		                           % as graphical object found among elements in given figure.
		jf=1;
		ja=1;
		js=1;
		ju=1;
		for j=1:2:Nvar-1
			inp=varargin{j};
			val=varargin{j+1};
			if ~any( strcmp(lower(inp) , known_inputs) )
				%switch input reference:
				%	figure
				if strcmp( lower(inp(end-1:end)) , '_f' )
					UNKF{jf,1}=inp(1:end-2);
					UNKF{jf,2}=val;
					jf=jf+1;
				%	axis
				elseif strcmp( lower(inp(end-1:end)) , '_a' )
					UNKA{ja,1}=inp(1:end-2);
					UNKA{ja,2}=val;
					ja=ja+1;
				%   to be specified in value
				elseif strcmp( lower(inp(end-1:end)) , '_@' )
					UNKS{js,1}=inp(1:end-2);
					UNKS{js,2}=val{1}; % type: specific objcet type to search
					UNKS{js,3}=val{2}; % value: value to assign
					js=js+1;
				%	unspecified
				else
					UNKU{ju,1}=inp;
					UNKU{ju,2}=val;
					ju=ju+1;
				end				
			end
		end
	end
	
	%% preset
	if preset_defined
		switch PRESET
			case 0
			%NO GRAPHIC CHANGES
			makechanges=false;
		
			case 1
			%FULLSCREEN
			FontSize          = 12; %default=10
			FontSize_TextBox  = 12; %default=10
			FontName          = 'Helvetica'; %default=Helvetica
			LineWidth         = 1;%default=0.5
			LineWidth_TextBox = 1; %default=0.5
			MarkerSize        = 7; %default=6
			
			case 2
			%FULLSCREEN
			FontSize          = 18; %default=10
			FontSize_TextBox  = 16; %default=10
			FontName          = 'Helvetica'; %default=Helvetica
			LineWidth         = 1.5;%default=0.5
			LineWidth_TextBox = 1.5; %default=0.5
			MarkerSize        = 9; %default=6
			
			case 3
			%Plane model
			FontSize          = 12; %default=10
			FontSize_TextBox  = 12; %default=10
			FontName          = 'Helvetica'; %default=Helvetica
			LineWidth         = 0.5;%default=0.5
			LineWidth_TextBox = 1.5; %default=0.5
			MarkerSize        = 6; %default=6
			
			otherwise
			error(['PRESET ',num2str(PRESET),' not available. Available presets are 0, 1, 2, 3.']);
		end
	end
	
	%% what to change
	if makechanges
		if preset_defined
			if PRESET~=0
				modify_fontname = 1;
				modify_fontsize = 1;
				modify_lnwdth  = 1;
				modify_mrksize = 1;
			end
		else
			%======================================================
			% Set MarkerSize
			if mrksize_defined
				if ~ischar(mrksize)
					MarkerSize = mrksize;
				end
				if ischar(mrksize)&&strcmp(mrksize,'dt')
					mrksize='donttouch';
				end
			else
				mrksize = MarkerSize;
			end
			% Check if MarkerSize has to be changed
			input_defined = mrksize_defined;
			input         = mrksize;
			modify_mrksize = (  input_defined ||( input_defined && ~ischar(input) )||( input_defined && ischar(input) && ~strcmp(lower(input),'donttouch') )  );
			%--------------------------------------------------------
			
			%======================================================
			% Set LineWidth
			if lnwdth_defined
				if ~ischar(lnwdth)
					LineWidth = lnwdth;
				end
				if ischar(lnwdth)&&strcmp(lnwdth,'dt')
					lnwdth='donttouch';
				end
			else
				lnwdth = LineWidth;
			end
			% Check if LineWidth has to be changed
			input_defined = lnwdth_defined;
			input         = lnwdth;
			modify_lnwdth  = (  input_defined ||( input_defined && ~ischar(input) )||( input_defined && ischar(input) && ~strcmp(lower(input),'donttouch') )  );
			%--------------------------------------------------------
			
			%======================================================
			% Set FontSize
			if fontsize_defined
				if ~ischar(fontsize)
					FontSize = fontsize;
				end
				if ischar(fontsize)&&strcmp(fontsize,'dt')
					fontsize='donttouch';
				end
			else
				fontsize = FontSize;
			end
			% Check if FontSize has to be changed
			input_defined = fontsize_defined;
			input         = fontsize;
			modify_fontsize  = (  input_defined ||( input_defined && ~ischar(input) )||( input_defined && ischar(input) && ~strcmp(lower(input),'donttouch') )  );
			%--------------------------------------------------------
			
			%======================================================
			% Set FontName
			if fontname_defined
				if ischar(fontsize)&&strcmp(fontsize,'dt')
					fontsize='donttouch';
				end
			else
				fontname = FontName;
			end
			% Check if FontName has to be changed
			input_defined = fontname_defined;
			input         = fontname;
			modify_fontname  = (  input_defined ||( input_defined && ischar(input) && ~strcmp(lower(input),'donttouch') )  );
			%--------------------------------------------------------
		end
		
		%======================================================
		% Set Legend Position
        if ~legpos_defined || legpos_defined&&ischar(legpos)&&strcmp(legpos,'dt')
            legpos='donttouch';
        end
		%--------------------------------------------------------
		
		%change_text_box_font_size=1;
	end
	
	%======================================================
	% Set MakeFullscreen
	if mkfllscr_defined
		if strcmp(mkfllscr,'yes')
			mkfllscr=1;
		elseif strcmp(mkfllscr,'no')
			mkfllscr=0;
		elseif strcmp(mkfllscr,'restore')
			mkfllscr= -1;
		else
			mkfllscr=0;
		end
	else
		mkfllscr=0;
	end
	%--------------------------------------------------------
	
		
	% save array of properties
	fig_properties = properties(gcf);
	ax_properties = properties(gca);
	
	
	%% property editing
	for j=1:length(figNvect)
		
		thisFigure=figure(figNvect(j));
		Nchildren = length(thisFigure.Children);
			
		fprintf('Editing:  Figure %d  . . .\n',thisFigure.Number);
		
		
		% AXES PROPERTIES
		figure_axes = findall( thisFigure.Children, 'type', 'Axes' );
		if xlim_defined
			try set( figure_axes , 'XLim' , xlim ); catch ME; fprintf('ERROR:: setting:  XLim\n'); warning(ME.message); end
		end
		if ylim_defined
			try set( figure_axes , 'YLim' , ylim ); catch ME; fprintf('ERROR:: setting:  YLim\n'); warning(ME.message); end
		end
		if zlim_defined
			try set( figure_axes , 'ZLim' , zlim ); catch ME; fprintf('ERROR:: setting:  ZLim\n'); warning(ME.message); end
		end
		if xtick_defined
			try set( figure_axes , 'XTick' , xtick ); catch ME; fprintf('ERROR:: setting:  XTick\n'); warning(ME.message); end
		end
		if ytick_defined
			try set( figure_axes , 'YTick' , ytick ); catch ME; fprintf('ERROR:: setting:  YTick\n'); warning(ME.message); end
		end
		if ztick_defined
			try set( figure_axes , 'ZTick' , ztick ); catch ME; fprintf('ERROR:: setting:  ZTick\n'); warning(ME.message); end
		end
		for j=1:length(figure_axes)
			ax=figure_axes(j);
			if xlabel_defined
				xlabel(ax, labelx);
			end
			if ylabel_defined
				ylabel(ax, labely);
			end
			if zlabel_defined
				zlabel(ax, labelz);
			end
			if title_defined
				title(ax, titlestring);
			end
			if grid_defined
				grid(ax,gridval);
			end
			if colorbar_defined
				if strcmp(cbarval,'on')
					colorbar(ax)
				else 
					colorbar(ax, 'off')
				end
			end
			if view_defined
				view(ax,viewval);
			end
		end
		
		% TRY SETTING UNKNOWN PARAMETERS
		% axes
		if nunka~=0
			for j=1:length(figure_axes)
				ax=figure_axes(j);
				for j=1:nunka
					inp=UNKA{j,1};
					val=UNKA{j,2};
					try 
						fprintf('Processing UNK (axes) input:  %s.\n',inp)
						set(ax,inp,val)
					catch ME
						fprintf('* ERROR: Setting UNK (axes) input:  %s\n',inp);
						fprintf('*            Input name:   %s\n',inp);
						classval=class(val);
						if isnumeric(val), val=num2str(val);end
						fprintf('*            Input value:  %s\n',val);
						fprintf('*            Value class:  [%s]\n', classval );
						fprintf('******* ErrMsg: %s\n',ME.message)
						fprintf('\n');
					end
				end
			end
		end
		
		
		for j=1:Nchildren
			child=thisFigure.Children(j);
			if makechanges
				try child.XAxis.FontName = FontName; end
				try child.XAxis.FontSize = FontSize; end
				try child.YAxis.FontName = FontName; end
				try child.YAxis.FontSize = FontSize; end
				try child.ZAxis.FontName = FontName; end
				try child.ZAxis.FontSize = FontSize; end
				if modify_mrksize				
					set( findall(child, 'type', 'line'), 'MarkerSize', MarkerSize );
				end
				if modify_lnwdth				
					set( findall(child, 'type', 'line'), 'LineWidth', LineWidth );
				end
				if modify_fontsize
					set( findall(child, 'type', 'Text'        ), 'FontSize',  FontSize );
					set( findall(child, 'type', 'Legend'      ), 'FontSize',  FontSize );
					set( findall(child, 'type', 'ColorBar'    ), 'FontSize',  FontSize );
					set( findall(child, 'type', 'NumericRuler'), 'FontSize',  FontSize );
				end
				if modify_fontname
					set( findall(child, 'type', 'Text'        ), 'FontName',  FontName );
					set( findall(child, 'type', 'Legend'      ), 'FontName',  FontName );
					set( findall(child, 'type', 'ColorBar'    ), 'FontName',  FontName );
					set( findall(child, 'type', 'NumericRuler'), 'FontName',  FontName );
				end
				%try set(child.LineWidth,LineWidth);end
				%try set(child.FontSize,FontSize);  end
				%try set(child.FontName,FontName);  end
				if ~strcmp(lower(legpos),'donttouch')
					set( findall(child, 'type', 'Legend'), 'Location',  legpos );
				end
			end
			
						
			% TRY SETTING UNKNOWN PARAMETERS
			% specific value to search -> all figure children (axes, ...)
			if nunks~=0
				for j=1:nunks
					inp=UNKS{j,1};
					typ=UNKS{j,2};
					val=UNKS{j,3};
					try 
						fprintf('Processing UNK (specific object: "%s") input:  "%s"\n',typ,inp);
						allspecific=findall(child, 'type', typ);
						%findall considers also partial types: e.g. it will find 'uitab' and 'uitabgroup' under the same 'type'='uitab'.
						% then only exaclty matching types will be retained.
						klogic=true(1,length(allspecific));
						for k=1:length(allspecific)
							cobj = allspecific(k);
							if ~strcmp( lower(cobj.Type), lower(typ) )
								klogic(k)=false;									
							end
						end
						allspecific2=allspecific(klogic);	
						
						if isempty(allspecific2) 
							fprintf('\\__No graphic object of type "%s" found in current axes child  (child type:  ''%s'').\n',typ,child.Type)
							fprintf(' \\__Trying enforcing it as axes property''s property:\n',typ)
							%ex: <'fontsize_@', {'XLabel',10}> --> inp= 'fontsize' , typ= 'XLabel', val= 10
							%    if 'XLabel' is a property of current axes   and   if 'fontsize' is a property of 'XLabel'
							%    then  the value 10 will be applied
							done=0;
							if any(strcmp( ax_properties, typ))
								field = getfield(gca,typ);
								if any( strcmp( lower(properties(field)), lower(inp)) )
									set( field , inp, val)
									fprintf('  \\__Done.\n')
									done=1;
								end
							end
							if ~done
								fprintf('  \\__Failed.\n')
								if ~UNKS_logic(j)
									fprintf('   \\__Trying enforcing it as graphical object''s property if found in this figure:\n',typ)
									UNKS_logic(j)=true;
									allobj=findall(thisFigure,'type',typ);
									if ~isempty(allobj)
										%findall considers also partial types: e.g. it will find 'uitab' and 'uitabgroup' under the same 'type'='uitab'.
										% then only exaclty matching types will be retained.
										klogic=true(1,length(allobj));
										for k=1:length(allobj)
											cobj = allobj(k);
											if ~strcmp( lower(cobj.Type), lower(typ) )
												klogic(k)=false;									
											end
										end
										allobj2=allobj(klogic);
										if ~isempty(allobj2)
											if any(strcmp( lower(properties(allobj2(1))), lower(inp)))
												set( allobj2 , inp, val)
												fprintf('    \\__Done.\n')
											else
												fprintf('    \\__Failed: no property "%s" found in object "%s".\n',inp,typ)
											end
										else
											fprintf('    \\__Failed: no objcet found of type "%s".\n',typ);
										end
									else
										fprintf('    \\__Failed: no objcet found of type "%s".\n',typ);
									end
								else
									fprintf('   \\__Already tried enforcing it as graphical object''s property if found in this figure:\n',typ)
								end
							end
							clear done;
							
						else
							if any( strcmp( lower(properties(allspecific2(1))), lower(inp)) )
								set( allspecific2, inp, val );
								fprintf('\\__Done.\n');
							else
								fprintf('\\__Failed: no property "%s" found in object "%s".\n',inp,typ)
							end
						end
					catch ME
						fprintf('* ERROR: Setting UNK (specific object: "%s") input:  "%s"\n',inp,typ);
						fprintf('*            Input name:   %s\n',inp);
						fprintf('*            Input object: %s\n',typ);
						classval=class(val);
						if isnumeric(val), val=num2str(val);end
						fprintf('*            Input value:  %s\n',val);
						fprintf('*            Value class:  [%s]\n', classval );
						fprintf('******* ErrMsg: %s\n',ME.message)
						fprintf('\n');
					end
				end
			end
			% unspecified -> all figure children
			if nunku~=0
				for j=1:nunku
					inp=UNKU{j,1};
					val=UNKU{j,2};
					try 
						fprintf('Processing UNK (unspecified) input as axes property:  %s\n',inp);
						set(child,inp,val)
					catch ME
						fprintf('* ERROR: Setting UNK (unspecified) input as axes property:  %s\n',inp);
						fprintf('*            Input name:   %s\n',inp);
						classval=class(val);
						if isnumeric(val), val=num2str(val);end
						fprintf('*            Input value:  %s\n',val);
						fprintf('*            Value class:  [%s]\n', classval );
						fprintf('******* ErrMsg: %s\n',ME.message)
						fprintf('\n');
					end
				end
			end
			
		end%figure children loop
						
		% TRY SETTING UNKNOW INPUTS
		% figure inputs
		if nunkf~=0
			for j=1:nunkf
				inp=UNKF{j,1};
				val=UNKF{j,2};
				try 
					fprintf('Processing UNK (figure) input:  %s\n',inp);
					set(thisFigure,inp,val)
				catch ME
					fprintf('* ERROR: Setting UNK (figure) input:  %s\n',inp);
					fprintf('*            Input name:   %s\n',inp);
					classval=class(val);
					if isnumeric(val), val=num2str(val);end
					fprintf('*            Input value:  %s\n',val);
					fprintf('*            Value class:  [%s]\n', classval );
					fprintf('******* ErrMsg: %s\n',ME.message)
					fprintf('\n');
				end
			end
		end
		% unspecified
		if nunku~=0
			for j=1:nunku
				inp=UNKU{j,1};
				val=UNKU{j,2};
				try 
					fprintf('Processing UNK (unspecified) input as figure property:  %s\n',inp);
					set(thisFigure,inp,val)
				catch ME
					fprintf('* ERROR: Setting UNK (unspecified) input as figure property:  %s\n',inp);
					fprintf('*            Input name:   %s\n',inp);
					classval=class(val);
					if isnumeric(val), val=num2str(val);end
					fprintf('*            Input value:  %s\n',val);
					fprintf('*            Value class:  [%s]\n', classval );
					fprintf('******* ErrMsg: %s\n',ME.message)
					fprintf('\n');
				end
			end
		end			
		
		if mkfllscr==1
			thisFigure.Units='Normalized';
			thisFigure.OuterPosition=[0 0 1 1];
			thisFigure.Position=[0         0                   0.956770833333333 0.912962962962963];
		end
		if mkfllscr==-1
			defsize = [0.033333333333333   0.263888888888889   0.373958333333333 0.589814814814815];
			defpos =  [0.317057291666667   0.394675925925926   0.364583333333333 0.486111111111111];
			thisFigure.Units='Normalized';
			thisFigure.OuterPosition=defsize;
			thisFigure.Position=defpos;
		end
			
		
		%done setting properties
		figure(thisFigure);	
		fprintf('Done editing:  Figure %d.\n\n',thisFigure.Number);
		
		% reset UNKS_logic
		UNKS_logic=false(nunks,1);
		
	end%figure-loop
	

	
end
	

	
	
	%%thisFigure=gcf;
	%%child=thisFigure.Children(2)
	%%set( findall(child, 'type', 'Surface'), 'EdgeColor',  'k' );
	%%set( findall(child, 'type', 'Surface'), 'EdgeColor',  'none' );
	%%set( findall(child, 'type', 'Surface'), 'EdgeAlpha',  0.5 );
	%%set( findall(child, 'type', 'Surface'), 'LineWidth',  0.5 );
	%%set( findall(child, 'type', 'Surface'), 'EdgeLighting', 'none'  );
	%%set( findall(child, 'type', 'Surface'), 'Marker', 'none'  );
	%%AlphaData = [1 0.5 ; 0.5 0.5];
	%%set( findall(child, 'type', 'Surface'), 'AlphaData',  AlphaData );
	%%set( findall(child, 'type', 'Surface'), 'EdgeAlpha',  'flat' );
	
	
