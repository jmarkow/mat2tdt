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

if ~isfield(OBJ.status,'recording_enabled')
    OBJ.status.recording_enabled=false;
end

if OBJ.status.circuit_loaded
	OBJ.status.buffer_exists=false;
	if isstruct(OBJ.tags)
		OBJ.status.buffer_exists=any(strcmp(fieldnames(OBJ.tags),'BufferData'));
	end
end

% if a gui exists, you know, do stuff


chk_status={'circuit_loaded','circuit_running','dev_connected','zbus_connected','recording_enabled'};

% status updates

if isfield(OBJ.gui_handles,'status')
	for i=1:length(chk_status)

		if isfield(OBJ.gui_handles.status,chk_status{i}) & ...
				ishandle(OBJ.gui_handles.status.(chk_status{i}))
			if OBJ.status.(chk_status{i})
				set(OBJ.gui_handles.status.(chk_status{i}),'string','Yes','ForegroundColor','g');
			else
				set(OBJ.gui_handles.status.(chk_status{i}),'string','No','ForegroundColor','r');
			end
		end

	end

	if isfield(OBJ.gui_handles.status,'sampling_rate') & ...
			ishandle(OBJ.gui_handles.status.sampling_rate)
		set(OBJ.gui_handles.status.sampling_rate,'string',OBJ.status.sampling_rate);
	end

	if isfield(OBJ.gui_handles.button,'buffer_filename') & ...
			ishandle(OBJ.gui_handles.button.buffer_filename)
		set(OBJ.gui_handles.button.buffer_filename,'string',OBJ.status.sampling_rate);
	end


	% enable or disable the record button if it exists

	if isfield(OBJ.gui_handles.button,'record_buffer') & ...
		ishandle(OBJ.gui_handles.button.record_buffer)

		if OBJ.status.circuit_running & exist(OBJ.buffer_store,'file')==0
			set(OBJ.gui_handles.button.record_buffer,'enable','on');
		else
			set(OBJ.gui_handles.button.record_buffer,'enable','off');
		end

	end
end
