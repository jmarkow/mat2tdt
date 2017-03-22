function connect_device(OBJ)
%
%

if ~OBJ.status.zbus_connected
	fprintf('Not connected to zbus...\n');
	return;
end

OBJ.settings.zbus_address=OBJ.activex.zbus.GetDeviceAddr(OBJ.get_device_number(OBJ.settings.dev),1);
OBJ.settings.zbus_rack_num=ceil((OBJ.settings.zbus_address-1)/2);

fprintf('Connecting to device...');

switch lower(OBJ.settings.dev)
case 'rx8'
	connect_status=OBJ.activex.dev.ConnectRX8(upper(OBJ.settings.interface),1);
otherwise
	fprintf('Device %s currently not supported\n',OBJ.settings.dev);
end

if connect_status==1
	fprintf('success\n');
else
	fprintf('failed\n')
end

OBJ.update_status;
