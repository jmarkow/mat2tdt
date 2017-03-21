function connect_device(OBJ)
%
%

OBJ.settings.zbus_address=OBJ.activex.zbus.GetDeviceAddr(OBJ.get_device_number(OBJ.settings.dev),1);
OBJ.settings.zbus_rack_num=ceil((OBJ.settings.zbus_address-1)/2);

switch lower(OBJ.settings.dev)
case 'rx8'
	connect_status=OBJ.activex.dev.ConnectRX8(OBJ.settings.dev,1);
otherwise
	fprintf('Device %s currently not supported\n',OBJ.settings.dev);
end

if connect_status==0
	error('Error connecting to %s',OBJ.settings.dev)
end

OBJ.update_status;
