function update_status(OBJ)
%
%
%


OBJ.status.activex=strcmp(class(OBJ.activex.zbus),'COM.ZBUS_x')&strcmp(class(OBJ.activex.dev),'COM.RPco_x');
OBJ.status.circuit_loaded=false;
OBJ.status.circuit_running=false;
OBJ.status.dev_connected=false;
OBJ.status.circuit_exists=exist(OBJ.settings.circuit_file,'file')==2;
% get basic properties if we have a running activex connection

if OBJ.status.activex
	dev_status=double(OBJ.activex.dev.GetStatus);
	OBJ.status.dev_connected=bitget(dev_status,1);
	OBJ.status.circuit_loaded=bitget(dev_status,2);
	OBJ.status.circuit_running=bitget(dev_status,3);
	OBJ.status.zbus_connected=OBJ.activex.zbus.ConnectZBUS(OBJ.settings.interface)==1;
	OBJ.status.sampling_rate=OBJ.activex.dev.GetSFreq;
end

if OBJ.status.circuit_loaded
	OBJ.status.buffer_exists=false;
	if isstruct(OBJ.tags)
		OBJ.status.buffer_exists=any(strcmp(fieldnames(OBJ.tags),'BufferData'));
	end
end
