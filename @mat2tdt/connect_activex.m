function connect_activex(OBJ)
% Sets the activex controls
%
%
%

if OBJ.status.activex
	fprintf('Activex already connected...\n');
	return;
end

fprintf('Connecting to activex...');

OBJ.activex.zbus=actxcontrol('ZBUS.x',[1 1 1 1]);
OBJ.activex.dev=actxcontrol('RPco.x',[5 5 26 26]);

OBJ.update_status;

if OBJ.status.activex
	fprintf('success\n');
else
	fprintf('failed\n');
end
