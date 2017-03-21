function reset(OBJ)
%
%
%

if ~(OBJ.status.activex&~isempty(OBJ.settings.zbus_rack_num))
	fprintf('Need activex connection and zbus settings (run init).\n');
end

OBJ.activex.zbus.HardwareReset(OBJ.settings.zbus_rack_num);
disp('Initiating hardware reset, pausing for 60 seconds...')
pause(60);
