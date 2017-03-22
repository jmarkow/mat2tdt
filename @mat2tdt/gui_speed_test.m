function gui_speed_test(OBJ)
%
%
%

% assumes our start and stop triggers are soft trigs behavior_model

if ~(OBJ.status.buffer_exists&OBJ.status.circuit_running)
	fprintf('Need to have a running circuit with a buffer...\n');
	return;
end

% TODO: on cleanup, a bunch of dialog boxes and a GUI for specifying a filepath

button_dialog = figure();
button_h = uicontrol(button_dialog,'Style', 'PushButton', ...
                    'String', 'Break', 'Position',[50 50 200 200],...
                    'Units','Normalized','Callback', 'delete(gcbf)');


fid=fopen('testing.bin','Wb');
finish_up=onCleanup(@() gui_cleanup(OBJ,fid,button_dialog));

status=OBJ.activex.dev.SoftTrg(2);
status=OBJ.activex.dev.SoftTrg(1);

if status==1
	fprintf('Buffer recording started\n');
else
	error('Could not start buffer');
end

recording_loop(OBJ,fid,button_dialog);

% stop the buffer dun

% OBJ.activex.dev.SoftTrg(2);
% fclose(fid);
% fprintf('Buffer stopped...\n');
