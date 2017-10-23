function recording_loop_gui(SRC,EVENT,OBJ)
%
%

OBJ.status.recording_enabled=true;
set(OBJ.gui_handles.button.stop_buffer,'enable','on');
OBJ.update_status;

% save everything to json foolio

[filename,pathname,ext]=fileparts(OBJ.buffer_store);

fprintf('Saving metadata...');
save_metadata.tags=OBJ.tags;
save_metadata.metadata=OBJ.metadata;
save_metadata.status=OBJ.status;
save_metadata.settings=OBJ.settings;
savejson('',save_metadata,fullfile(filename,[ pathname '.json']));
fprintf('success\n');

[fid,status]=fopen(OBJ.buffer_store,'w');

if isempty(status)
	fprintf('Will save data to %s\n',OBJ.buffer_store);
else
	fprintf('%s',status);
	return;
end

finish_up=onCleanup(@() gui_cleanup(OBJ,fid,[]));

status=OBJ.activex.dev.SoftTrg(2);
status=OBJ.activex.dev.SoftTrg(1);

if status==1
	fprintf('Buffer recording started\n');
else
	error('Could not start buffer');
end

pause(1e-4);
recording_loop(OBJ,fid,SRC);

status=OBJ.activex.dev.SoftTrg(2);
fclose(fid);

OBJ.status.recording_enabled=false;

if status==1
	fprintf('Buffer stopped...\n')
end

set(OBJ.gui_handles.button.stop_buffer,'enable','off');
OBJ.update_status;
