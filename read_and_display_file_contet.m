


function read_and_display_file_content(fname)
%|
%| function  read_and_display_file_content(fname)
%|=====================================================================================
%| READ_AND_DISPLAY_FILE_CONTENT reads and displays on screen the input files content.
%|
%|-------------------------------------------------------------------------------------
%|  INPUTS:
%|		fname    [char]    Name of file, or a filter for files that have to be read.
%|
%|-------------------------------------------------------------------------------------
%|  OUTPUTS:
%|      display on screen the content of givent input files.
%|
%|=====================================================================================
%|	EXAMPLES.
%|		fname= 'readme.txt'    will read readme.txt and display its content on screen.
%|		fname= '*.txt'         will read all .txt files in current directory and 
%|		                        display their content on screen.
%|_____________________________________________________________________________________
%|_____________________________________________________________________________________
%|Author: ni-il
%\_____________________________________________________________________________________


	mylist=ls(fname);
	l=size(mylist,1);
	for j=1:l
		fname=strtrim(mylist(j,:));
		%f=fopen(  );
		ftext=fileread( fname );
		fprintf( 'FILE:  %s\n%s\n\n',fname,ftext);
	end
	