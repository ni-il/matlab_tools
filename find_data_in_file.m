


function data = find_data_in_file(filename,headerOfData,varargin)
%|
%| function  data = find_data_in_file(filename,headerOfData,varargin)
%|
%|=====================================================================================
%|  INPUTS:
%|	  filename        [char]    name of target file (with extension).
%|	  headerOfData    [char]    header of target data 
%|
%|    varargin:
%|      varargin must be given as couple of <[char] input_name, [ ] input_value>.
%|        
%|      Varargin syntax:
%|        ...,[char] input_name  ,[ ] input_value,...
%|	        
%|  	input_name     input_value  
%|
%|		'Multi'          >> [char]  'on'/'off'  :
%|				            Search target file for multiple data with the same header.
%|		    	            Return a vector containing all data found.
%|				            If 'multi' is 'off' then only the first data found will be
%|                          returned.
%|		                 
%|		'OutChar'        >> [char]  'on'/'off'  : 
%|				            Return output as char (instead of as double).
%|  	    	            Can't be used when 'multi' is 'on' ('multi' will be set 
%|                          'off').
%|		                 
%|		'IfComposed'     >> [cell]  {[char] delimiter, [double] whichpart}  :
%|                          Elaborate composed strings. 
%|                          Example: "HeaderOfdata 1234 [unit]"
%|                          Cell must contain:
%|  	                    - [char] delimiter  :
%|                               Specifies the character used to split the data string 
%|                               (in the example, delimiter=' ' leads to 
%|                               [string]("1234","[unit]")).
%|				            - [double] whichpart  : 
%|                               [[integer, positive, vector]]
%|                               Must be integer and positive and may be a vector.
%|                               Specifies the part that has to be kept (in the example, 
%|                               whichpart=1 leads to data=1234). 
%|                               It can be a vector in order to keep different parts.
%|				              	               						                                                           
%|		'GoToNewLine'    >> [double] linestoskip  :  [[integer, positive]]
%|                          Searche data not at the end of HeaderOfdata, but at the
%|                          beginning of next n lines, where n is linestoskip 
%|                          (if linestoskip==1 then data is considered to be in the 
%|                          next line following the one containing HeaderOfdata).
%|			
%|      'HeaderPosition' >> [char] 'left'/'right'  :  
%|		                    Specify the HeaderOfdata position in the text string read. 
%|				            Default is 'left'.
%|
%|		'SkipFrom'       >> [cell]  {[char] skipdirection, [double] ntoskip}  :
%|                          Allow to skip ntoskip characters from line start ('left') 
%|                          or from  line end ('right') (same direction of 
%|                          ''HeaderPosition'').
%|                          Cell must contain:
%|				            - [char] skipdirection  :  [['left'/'right']]
%|                              Specify the direction.
%|				            - [double] ntoskip  :  [[integer, positive]]
%|                              Specify the number of lines to be skept.
%|                              Default is 0.
%|                              This creates a zone that will be skept by this 
%|                              function.
%|
%|		'TrimData'       >> [cell]  {[char] trimdirection, [char] whattotrim}  :
%|                          Allow the removal of whattotrim from data in direction 
%|                          specified by 'trimdirection'.
%|                          Cell must contain:
%|				            - [char]   trimdirection  :  [['left'/'right/anywhere']]
%|				              'left'/'right' : remove 'whattotrim' from left or from
%|                            right (one time only).
%|                            'anywhere'     : remove 'whattotrim' anywhere in data
%|                            string.
%|		
%|-------------------------------------------------------------------------------------			
%|  OUTPUTS:
%|     data    [double/char]    data following HeaderOfdata  
%|
%|=====================================================================================
%|  EXAMPLES: 
%|
%|	  File  loads.txt   contains informations about the static margin of an aircraft.
%|    Extrapolation of the file content is reported hereafter:
%|	    line 88|...
%|	    line 89|STABILITY
%|	    line 90| Static margin          (XN-XCG)/CREF    0.10816  
%|	    line 91|...
%|      line 92|...
%|      line 93|...
%|    In order to obtain the value of the static margin (0.10816), this function can
%|    be used with:
%|	   input:
%|		 filename 	  = 'loads.txt'
%|		 headerOfData = ' Static margin          (XN-XCG)/CREF';
%|    
%|   >>data = find_data_in_file(filename,headerOfData,varargin)
%|
%|   output:
%|     data = 0.10816
%|	
%|_____________________________________________________________________________________
%|Author: ni-il
%\_____________________________________________________________________________________
	
	
	lv=length(varargin);
	if rem(lv,2)
		error('varargin must be pairs of <''dataname''> and <value>.')
	end
	flag_multi=0;
	flag_outchar=0;
	flag_ifcomposed=0;
	flag_gotonewline=0;
	flag_headeronright=0;
	leftskip=0; rightskip=0;
	flag_trimdata=0;
	for j=1:2:lv
		d=varargin{j};
		v=varargin{j+1};
		switch lower(d)
			% Multi
			case 'multi'
				if ~ischar(v)
					error('''multi'' value must be char [''on''/''off''].')
				end
				switch lower(v)
					case 'on'
						flag_multi=1;
					case 'off'
						flag_multi=0;
					otherwise
						error('''multi'' value must be ''on''/''off''.')
				end
			% OutChar
			case 'outchar'
				if ~ischar(v)
					error('''outchar'' value must be char [''on''/''off''].')
				end
				switch lower(v)
					case 'on'
						flag_outchar=1;
					case 'off'
						flag_outchar=0;
					otherwise
						error('''outchar'' value must be ''on''/''off''.')
				end
			% IfComposed
			case 'ifcomposed'
				if ~iscell(v)
					error('''IfComposed'' value must be {''delimiter'',whichpart}.');
				end
				flag_ifcomposed=1;
				delimiter=v{1};
				whichpart=v{2};
				if ~ischar(delimiter)
					error('In ''IfComposed'' value {''delimiter'',whichpart}, ''delimiter'' must be char.')
				end
				if ~isnumeric(whichpart)
					error('In ''IfComposed'' value {''delimiter'',whichpart}, whichpart must be double.')
				end
				if rem(whichpart,1) || whichpart<0 %not integer
					error('In ''IfComposed'' value {''delimiter'',whichpart}, whichpart must have positive integer value.')
				end
			% GoToNewLine
			case 'gotonewline'
				if ~isnumeric(v)
					error('''GoToNewLine'' value must be numeric.');
				end
				if rem(v,1) || v<0 %not integer
					error('''GoToNewLine'' value must be positive integer.')
				end
				flag_gotonewline=1;
				linestoskip=v;
			% HeaderPosition
			case 'headerposition'
				if ~ischar(v)
					error('''HeaderPosition'' value must be char (''left''/''right'').')
				end
				switch lower(v)
					case 'right'
						flag_headeronright=1;
					case 'left'
					otherwise
						error('''HeaderPosition'' value must be ''left''/''right''.')
				end
			% SkipFrom
			case 'skipfrom'
				if ~iscell(v)
					error('''SkipFrom'' value must be {''skipdirection'',ntoskip}.');
				end
				skipdirection=v{1};
				ntoskip=v{2};
				if ~ischar(skipdirection)
					error('In ''SkipFrom'' value {''skipdirection'',ntoskip}, ''skipdirection'' must be char.')
				end
				if ~isnumeric(ntoskip) || rem(ntoskip,1) || ntoskip<0 %not integer
					error('In ''SkipFrom'' value {''skipdirection'',ntoskip}, ntoskip must be double and its value must be positive integer.')
				end
				switch lower(skipdirection)
					case 'right'
						rightskip=ntoskip;
					case 'left'
						leftskip=ntoskip;
					otherwise
						error('In ''SkipFrom'' value {''skipdirection'',ntoskip}, ''skipdirection'' must be ''left''/''right''.')
				end
			% TrimData
			case 'trimdata'
				if ~iscell(v)
					error('''TrimData'' value must be {''trimdirection'',''whattotrim''}.');
				end
				flag_trimdata=1;
				trimdirection=v{1};
				whattotrim=v{2};
				if ~ischar(trimdirection)
					error('In ''TrimData'' value {''trimdirection'',''whattotrim''}, ''trimdirection'' must be char.')
				end
				if ~ischar(whattotrim)
					error('In ''TrimData'' value {''trimdirection'',''whattotrim''}, ''whattotrim'' must be char.')
				end
				trimdirection=lower(trimdirection);
				if ~strcmp(trimdirection,'left')&&~strcmp(trimdirection,'right')&&~strcmp(trimdirection,'anywhere')
					error('In ''TrimData'' value {''trimdirection'',''whattotrim''}, ''trimdirection'' must be ''left''/''right''/''anywhere''.')
				end		
			% otherwise
			otherwise
				error(['Unrecognized input: ',d,'.']);
		end
	end
	%if nargin==2
	%	flag_multi=0;
	%end
	
		
	
	if flag_multi
		datavect=[];
	end
	
	l=length(headerOfData);
	data=NaN;
	fid=fopen(filename);
	while 1
		tline_original = fgetl(fid);
		tline_trimmed=tline_original(1+leftskip:end-rightskip);
		tline=tline_trimmed;
		%disp(tline);
		if ~ischar(tline)
			break
		end
		
		if length(tline)>=l
			% check HEADER ('SkipData' included here)
			%   on LEFT
			if ~flag_headeronright 
				found=strcmp(tline(1:l),headerOfData);
				% TODO: partialheader
				%if flag_partialheader
				%	found=0;
				%	for j=1:length(tline)-l
				%		if strcmp(tline(j,j+l),headerOfData)
				%			found=1;
				%			break
				%		end
				%	end
				%else
				%	found=strcmp(tline(1:l),headerOfData);
				%end
				%
			%   on RIGHT
			else
				found=strcmp(tline(end-l+1:end),headerOfData);
				%disp(tline(end-l+1:end))
				% TODO: partialheader
				%if flag_partialheader
				%	found=0,
				%	for j=1:length(tline)-l
				%		if strcmp(tline(end+2-j-l,end+1-j),headerOfData)
				%			found=1;
				%			break
				%		end
				%	end
				%else
				%	found=strcmp(tline(end-l+1:end),headerOfData);
				%end
			end
			
			if found
				if flag_gotonewline
					for j=1:linestoskip
						tline = fgetl(fid); %it is not trimmed here
					end
					dataraw=strtrim(tline);
				else					
					dataraw=strtrim(strrep(tline,headerOfData,''));
				end
				% trim data
				if flag_trimdata
					switch trimdirection
						case 'left'
							for j=1:length(dataraw)
								pos=[j:j+length(whattotrim)-1];
								if strcmp(dataraw(pos),whattotrim)
									dataraw(pos)='';
									break
								end
							end		
						case 'right'
							END=length(dataraw);
							for j=1:length(dataraw)
								pos=[END+2-j-length(whattotrim):END+1-j];
								if strcmp(dataraw(pos),whattotrim)
									dataraw(pos)='';
									break
								end
							end	
						case 'anywhere'
							dataraw=strrep(dataraw,whattotrim,'');
					end
				end
				%dataraw to data
				if flag_ifcomposed
					parts=strsplit(dataraw,delimiter);
					if length(whichpart)==1
						data=parts{whichpart};
					else
						data=[];
						for j=1:length(whichpart)
							data=[data , [parts{whichpart(j)},'  ']];
						end
					end
				else
					data=dataraw;
				end
				%
				% OUTPUT
				if  ~flag_outchar
					data=str2num( data );
				end
				if ~flag_multi
					break
				else
					datavect=[datavect;data];
					if flag_outchar
						warning('Cant have more than first data with "multi" on and "outchar" on.')
						break
					end
				end
			end
		end		
	end
	
	fclose(fid);
	
	if flag_multi
		data=datavect;
	end
end
	