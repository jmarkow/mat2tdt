function gui_cleanup(OBJ,FIDS,HANDLES)
% Makes sure all figure handles and files are closed, just IN CASE
%
%
%

OBJ.status.recording_enabled=false;

fprintf('Cleaning up GUI...\n');

for i=1:length(FIDS)
	if fopen(FIDS(i))>-1
		fprintf('Closing %s...',fopen(FIDS(i)));
		status=fclose(FIDS(i));
		if status==0
			fprintf('succeeded\n')
		else
			fprintf('failed\n')
		end
	end
end

for i=1:length(HANDLES)
	if ishandle(HANDLES(i))
		delete(HANDLES(i));
	end
end

%status=OBJ.activex.dev.SoftTrg(2);
% 
% if status==1
% 	fprintf('Buffer stopped successfully\n');
% else
% 	fprintf('Buffer did NOT stop correctly\n');
% end
