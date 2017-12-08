function recording_loop(OBJ,FID,HANDLE)
%
%
%

transfer_pts=OBJ.tags.BufferSize/2;

while ishandle(HANDLE) & OBJ.status.recording_enabled

	% I wonder if this is what's causing our problems...
	% replace w/ a short pause or java.lang.Thread.sleep

	%drawnow();

	% wait until the first half of the buffer fills

	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

  count=0;
  warning_issued=false;

	while cur_idx<transfer_pts
    pause(1e-4);
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
    count=count+1;
    if count>OBJ.settings.buffer_warning & ~warning_issued
      OBJ.set_buffer_status('u');
      fprintf('Buffer index is not incrementing, restart...\n');
      warning_issued=true;
    end
	end

	read_data=OBJ.activex.dev.ReadTagV('BufferData',0,transfer_pts);

	% write out the first half of the buffer

	fwrite(FID,read_data,'float32','ieee-be');
	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	if cur_idx<transfer_pts
		fprintf('Current transfer rate too slow to keep up...\n');
	end

  count=0;
  warning_issued=false;

	while cur_idx>transfer_pts
    pause(1e-4);
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
    if count>OBJ.settings.buffer_warning & ~warning_issued
      OBJ.set_buffer_status('u');
      fprintf('Buffer index is not incrementing, restart...\n');
      warning_issued=true;
    end
	end

	% append and do one write instead

	read_data=OBJ.activex.dev.ReadTagV('BufferData',transfer_pts,transfer_pts);

	% write the second chunk

	fwrite(FID,read_data,'float32','ieee-be');
	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	if cur_idx>transfer_pts
		fprintf('Current transfer rate too slow to keep up...\n');
	end

	pause(1e-4);

end

% if we have enough headroom, grab another 1/2 buffer after shutting off sync...

if cur_idx<transfer_pts & OBJ.settings.buffer_overhang

	cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');

	while cur_idx<transfer_pts
		cur_idx=OBJ.activex.dev.GetTagVal('BufferIndex');
	end

	% hurry up offense

	read_data=OBJ.activex.dev.ReadTagV('BufferData',0,transfer_pts);
	fwrite(FID,read_data,'float32','ieee-be');

end
