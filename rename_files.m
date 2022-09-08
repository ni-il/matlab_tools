


function SUCCESS = remane_files(file,tochange,changeto)
%|
%| function  SUCCESS = remane_files(file,tochange,changeto)
%|=====================================================================================
%| RENAME_FILES rename target files changing target part of the name. 
%| This function is based on Matlab movefile function.
%|
%|-------------------------------------------------------------------------------------
%|  INPUTS:
%|    file     : [char]   filename (if '*' is included it acts like a filter, selecting
%|                        various files).
%|    tochange : [char]   part of the name to be replaced.
%|    changeto : [char]   rename tochange to this.
%|
%|-------------------------------------------------------------------------------------
%|  OUTPUTS:
%|   	SUCCESS  : [double] =  1 if movefile succeded, 
%|                          =  0 if movefile not succeded.
%|                          = -1 if input file not available in current directory
%|                          NOTE: It is a vector Nx1 if N input files are provided.
%|                          
%|=====================================================================================
%|  EXAMPLES:
%|    file     ='TORUN_ANALYSIS_*.dat'
%|    tochange ='TORUN';
%|    changeto ='SOLVED';
%|_____________________________________________________________________________________
%|Author: ni-il
%\_____________________________________________________________________________________


lista=ls(file);
if isempty(lista)
	warning('No file with this name present in this directory');
	SUCCESS=-1;
	return
end
Nfile=size(lista,1);
SUCCESS=zeros(Nfile,1);
for j=1:Nfile
	old=strtrim(lista(j,:));
	new=strrep(old,tochange,changeto);
	[ok,message,messageid]=movefile(old,new);
	SUCCESS(j)=ok;
	if ok
		fprintf('%s --> %s\n',old,new);
	else
		fprintf('%s --X ERROR : <%d> %s\n',old,messageid,message);
	end
end
	