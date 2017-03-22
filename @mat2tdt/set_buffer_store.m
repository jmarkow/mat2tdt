function set_buffer_store(OBJ,STORE)
%

% make sure file path is writable

if isempty(STORE)

	% automagically set this, matching timestamps w/ K2 acquisition software

	filename=sprintf('tdt_data_%s.bin',datestr(datetime(now),'yyyymmddHHMMSS'));
	filepath=OBJ.settings.save_dir;

	use_file=fullfile(filename,filepath);
else
	use_file=STORE;
end

[path,file,ext]=fileparts(STORE);
[status,values]=fileattrib(path);

if values.UserWrite=1
	OBJ.buffer_store=use_file;
end
