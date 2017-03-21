function gui_cleanup(FIDS,HANDLES)
% Makes sure all figure handles and files are closed, just IN CASE
%
%
%

fprintf('Cleaning up GUI...\n');

for i=1:length(FIDS)
	status=fclose(FIDS(i));
	if status==0
		fprintf('Closed %s successfully\n',FIDS(i))
	else
		fprintf('Warning %s not closed succesfully\n',FIDS(i))
	end
end

for i=1:length(HANDLES)
	if ishandle(HANDLES(i))
		delete(HANDLES(i));
	end
end
