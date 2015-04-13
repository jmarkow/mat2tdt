function [DEV,DEV_STATUS]=connect_tdt(HW,INTERFACE,NUM)
%
%

% get the handle for the RX8

DEV=actxcontrol('RPco.x',[5 5 26 26]);

% open communication via USB

switch lower(HW)
	case 'rx8'
		DEV_STATUS=DEV.ConnectRX8(INTERFACE,NUM);
	case 'rz2'
		DEV_STATUS=DEV.ConnectRZ2(INTERFACE,NUM);
	case 'rz5'
		DEV_STATUS=DEV.ConnectRZ5(INTERFACE,NUM);
	otherwise
end

fprintf('%s initialization status %i\n',HW,DEV_STATUS);
