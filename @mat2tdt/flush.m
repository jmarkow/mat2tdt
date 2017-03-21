function flush(OBJ)
%
%
%
%

if ~(OBJ.status.activex&~isempty(OBJ.settings.zbus_rack_num))
	fprintf('Need activex connection and zbus settings (run init).\n');
end

io_status=zbus.FlushIO(OBJ.settings.zbus_rack_num);
fprintf('Zbus flush IO status %g\n',io_status);
