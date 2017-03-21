function connect_activex(OBJ)
% Sets the activex controls
%
%
%

OBJ.activex.zbus=actxcontrol('ZBUS.x',[1 1 1 1]);
OBJ.activex.dev=actxcontrol('RPco.x',[5 5 26 26]);

OBJ.update_status;
