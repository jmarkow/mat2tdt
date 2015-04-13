function [rx8,rx8_status,zbus,zbus_status,loadfile_status,fs]=init_tdt(loadfile,sr,reset,flush)
%
%

if nargin<4 | isempty(flush)
	flush=1;
end

if nargin<3 | isempty(reset)
	reset=0;
end
% flush zbus io, only one rack so need to loop here

zbus=actxcontrol('ZBUS.x',[1 1 1 1]);
zbus_status=zbus.ConnectZBUS('USB');
fprintf('Zbus connect status %g\n',zbus_status);

% get the rx8 address

addr=zbus.GetDeviceAddr(48,1);
rackno=ceil((addr-1)/2);

% pause for 60 seconds to allow device to reboot and
% restore connection

if reset
	zbus.HardwareReset(rackno);

	disp('Initiating hardware reset, pausing for 60 seconds...')
	pause(60);
end

zbus=actxcontrol('ZBUS.x',[1 1 1 1]);
zbus_status=zbus.ConnectZBUS('USB');
fprintf('Zbus second connect status %g\n',zbus_status);

% get the rx8 address again

addr=zbus.GetDeviceAddr(48,1);
rackno=ceil((addr-1)/2);

if flush
	io_status=zbus.FlushIO(rackno);
	fprintf('Zbus flush IO status %g\n',io_status);
end

% get the handle for the RX8

rx8=actxcontrol('RPco.x',[5 5 26 26]);

% open communication via USB

rx8_status=rx8.ConnectRX8('USB',1);

fprintf('RX8 initialization status %g\n',rx8_status);

% open RCO file 

if ~isempty(loadfile)
	fprintf('Loading file %s\n',loadfile);
	loadfile_status=rx8.LoadCOFsf([loadfile],sr);
end
fs=rx8.GetSFreq;

fprintf('RX8 sampling frequency %e, user specified sampling frequency %g\n',fs,sr);

