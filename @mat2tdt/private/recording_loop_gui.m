function recording_loop_gui(SRC,EVENT,OBJ)
%
%

set(SRC,'enabled','off')

[fid,status]=fopen(OBJ.buffer_store,'Wb');

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

recording_loop(OBJ,fid,SRC);

status=OBJ.activex.dev.SoftTrg(2);
fclose(fid);

OBJ.status.recording_enabled=false;

if status==1
	fprintf('Buffer stopped...\n')
end

set(SRC,'enabled','on')
