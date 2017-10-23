function stop_recording(SRC,EVENT,OBJ)
% yeah that's it boi
%
%

% shut everything off and bail bro

status=OBJ.activex.dev.SoftTrg(3);
OBJ.status.recording_enabled=false;
fprintf('Sent stop signal...\n');
%OBJ.update_status;
