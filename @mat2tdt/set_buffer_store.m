function set_buffer_store(OBJ,STORE)
%

if nargin<2
    STORE=[];
end
% make sure file path is writable

if isempty(STORE)

	% automagically set this, matching timestamps w/ K2 acquisition software

	filename=sprintf('tdt_data_%s.bin',datestr(datetime('now'),'yyyymmddHHMMSS'));
	filepath=OBJ.settings.save_dir;

	use_file=fullfile(filepath,filename);
else
	use_file=STORE;
end

[path,file,ext]=fileparts(use_file);

if ~exist(path,'dir')
    mkdir(path);
end

[status,values]=fileattrib(path);

if isstruct(values) & values.UserWrite==1
	OBJ.buffer_store=use_file;
end
