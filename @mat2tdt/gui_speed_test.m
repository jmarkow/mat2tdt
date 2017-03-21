function gui_speed_test(OBJ)
%
%
%

% assumes our start and stop triggers are soft trigs behavior_model

if ~(OBJ.status.buffer_exists&OBJ.status.circuit_running)
	fprintf('Need to have a running circuit with a buffer...\n');
	return;
end

status=OBJ.activex.dev.SoftTrg(1);

if status==1
	fprintf('Buffer recording started\n');
end

button_dialog = figure();
button_h = uicontrol(button_dialog,'Style', 'PushButton', ...
                    'String', 'Break', 'Position',[.1 .1 .8 .8],...
                    'Callback', 'delete(gcbf)');

transfer_pts=OBJ.tags.BufferSize/2;
fid=fopen('testing.bin','wb');

while (ishandle(button_dialog))

	% ensure the gui updates foolio

	drawnow();

	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	while cur_idx<transfer_pts
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
	end

	read_data=OBJ.activex.dev.ReadTagV('BufferData',0,transfer_pts);
	fwrite(fid,read_data,'float32','ieee-be');

	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
	if cur_idx<transfer_pts
		fprintf('Current transfer rate too slow to keep up...\n');
	end

	while cur_idx>transfer_pts
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
	end

	read_data=OBJ.activex.dev.ReadTagV('BufferData',transfer_pts,transfer_pts);
	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	if cur_idx>transfer_pts
		fprintf('Current transfer rate too slow to keep up...\n');
	end

end

% stop the buffer dun

OBJ.activex.dev.SoftTrg(2);
fclose(fid);

fprintf('Buffer stopped...\n');
