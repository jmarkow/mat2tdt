function update_status(OBJ)
%
%
%


OBJ.status.activex=~isempty(OBJ.activex.zbus) & ~isempty(OBJ.activex.dev);
OBJ.status.circuit_loaded=False;
OBJ.status.circuit_running=False;
OBJ.status.dev_connected=False;

% get basic properties if we have a running activex connection

if OBJ.status.activex
	dev_status=double(OBJ.activex.dev.GetStatus);
	OBJ.status.dev_connected=bitget(dev_status,1);
	OBJ.status.circuit_loaded=bitget(dev_status,2);
	OBJ.status.circuit_running=bitget(dev_status,3);
	OBJ.status.zbus_connection=OBJ.activex.zbus.ConnectZBUS(OBJ.settings.interface)==1;
	OBJ.status.sampling_rate=OBJ.activex.dev.GetSFreq;
end
