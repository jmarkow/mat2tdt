function recording_loop(OBJ,FID,HANDLE)
%
%
%

transfer_pts=OBJ.tags.BufferSize/2;

while ishandle(HANDLE) & OBJ.status.recording_enabled

	% ensure the gui updates foolio

	drawnow();

	% wait until the first half of the buffer fills

	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	while cur_idx<transfer_pts
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
	end

	read_data=OBJ.activex.dev.ReadTagV('BufferData',0,transfer_pts);

	% write out the first half of the buffer

	fwrite(FID,read_data,'float32','ieee-be');
	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	if cur_idx<transfer_pts
		fprintf('Current transfer rate too slow to keep up...\n');
	end

	while cur_idx>transfer_pts
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
	end

	% append and do one write instead

	read_data=OBJ.activex.dev.ReadTagV('BufferData',transfer_pts,transfer_pts);

	% write the second chunk

	fwrite(FID,read_data,'float32','ieee-be');
	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	if cur_idx>transfer_pts
		fprintf('Current transfer rate too slow to keep up...\n');
	end

end

% if we have enough headroom, grab another 1/2 buffer after shutting off sync...

if cur_idx<transfer_pts & OBJ.settings.buffer_overhang

	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	while cur_idx<transfer_pts
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
	end

	% hurry up offense

	read_data=OBJ.activex.dev.ReadTagV('BufferData',0,tranfer_pts);
	fwrite(FID,read_data,'float32','ieee-be');

end
