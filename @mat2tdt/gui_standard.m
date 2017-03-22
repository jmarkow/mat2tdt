function gui_standard(OBJ)
%
%
%

% TODO: create master GUI window for loading/running new circuits

if ~OBJ.status.circuit_loaded
	fprintf('Need to load a circuit first...\n');
	return;
end

OBJ.update_status;
OBJ.collect_tags;

tag_names=fieldnames(OBJ.tags);
rem_tags=~cellfun(@isempty,strfind(tag_names,'Buffer'));
tag_names(rem_tags)=[];

ntags=length(tag_names);

fontsize=10;
top_pos=.95;
bottom_pos=.4;
ncols=ceil(ntags/OBJ.settings.gui_rows_per_column)

column_width=(OBJ.settings.gui_width-50)/ncols;

tdt_figure=figure('Visible','off','Name',['TDT interface v.001a'],...
	'Position',[50,50,OBJ.settings.gui_width,...
    min(OBJ.settings.gui_row_height*ntags,OBJ.settings.gui_height)],...
	'NumberTitle','off',...
	'menubar','none','resize','on');

tag_axis=struct();
name_axis=struct();

column_margin=.05;
cur_pos=top_pos;

column_width=max(.05,(1/ncols-.05));
text_width=column_width*.65;
edit_width=column_width-text_width;
box_height=(top_pos-bottom_pos)/OBJ.settings.gui_rows_per_column;

for i=1:ntags

	% start at top
	% callback is to reset the tag if we edit the text

	cur_column=floor((i-1)/OBJ.settings.gui_rows_per_column);
    cur_row=rem(i-1,OBJ.settings.gui_rows_per_column)+1

	left_edge=cur_column*column_width+column_margin*min(cur_column,1);

	name_axis.(tag_names{i})=uicontrol(tdt_figure,'Style','text',...
		'String',tag_names{i},...
		'Units','Normalized',...
		'FontSize',fontsize,...
		'Position',[left_edge top_pos-box_height*cur_row text_width box_height/2]);

	pos=get(name_axis.(tag_names{i}),'position');

	tag_axis.(tag_names{i})=uicontrol(tdt_figure,'Style','edit',...
		'String',OBJ.tags.(tag_names{i}),...
		'Units','Normalized',...
		'FontSize',fontsize,...
		'Position',[pos(1)+pos(3)+.01 top_pos-box_height*cur_row edit_width box_height/1.5]);

	cur_pos=cur_pos-box_height-OBJ.settings.gui_row_spacing;

end

rem_top=bottom_pos-.175;

button_axis.update_tags=uicontrol(tdt_figure,'Style','PushButton',...
	'String',sprintf('Push tags to %s',OBJ.settings.dev),...
	'Units','Normalized',...
	'FontSize',fontsize,...
	'Position',[.05 rem_top .2 .075],...
	'Call',{@push_tags,tag_axis});

button_axis.run_circuit=uicontrol(tdt_figure,'Style','PushButton',...
	'String','Run',...
	'Units','Normalized',...
	'FontSize',fontsize,...
	'Position',[.05 rem_top-.075 .2 .075],...
	'Call',{@run_circuit_gui,OBJ});

button_axis.halt_circuit=uicontrol(tdt_figure,'Style','PushButton',...
	'String','Halt',...
	'Units','Normalized',...
	'FontSize',fontsize,...
	'Position',[.05 rem_top-.15 .2 .075],...
	'Call',{@halt_circuit_gui,OBJ});

status_bar={'circuit_loaded','circuit_running','sampling_rate'};

status_bar_height=rem_top./length(status_bar);

for i=1:length(status_bar)

	% format

	status_id=sprintf('%s_text',status_bar{i});
	status_text=sprintf('%s: ',regexprep(status_bar{i},'_',' '));
	status_text(1)=upper(status_text(1));

	status_axis.(status_id)=uicontrol(tdt_figure,'Style','text',...
			'String',status_text,...
			'Units','Normalized',...
			'Position',[.3 rem_top-.01-status_bar_height*(i-1) .11 status_bar_height]);

	status_axis.(status_bar{i})=uicontrol(tdt_figure,'Style','text',...
			'String','',...
			'Units','Normalized',...
			'Position',[.41 rem_top-.01-status_bar_height*(i-1) .1 status_bar_height]);

end

% alright add an effin' record buffer button bar

button_axis.buffer_filename=uicontrol(tdt_figure,'Style','Text',...
	'String',OBJ.buffer_store,
	'Units','Normalized',...
	'Position',[.61 rem_top-.01-.2 .2 .075]);

button_axis.get_new_file=uicontrol(tdt_figure,'Style','Pushbutton',...
	'String','Autofile',
	'Units','Normalized',...
	'Position',[.61 rem_top-.01 .2 .075],...
	'Callback',{@set_buffer_store_gui,button_axis.buffer_filename});

button_axis.get_new_file_dialog=uicontrol(tdt_figure,'Style','Pushbutton',...
	'String','...',
	'Units','Normalized',...
	'Position',[.61 rem_top-.01-.1 .2 .075]);

button_axis.record_buffer=uicontrol(tdt_figure,'Style','Pushbutton',...
	'String','Record buffer',
	'Units','Normalized',...
	'Position',[.61 rem_top-.4 .075]);

OBJ.gui_handles.status=status_axis;
OBJ.gui_handles.button=button_axis;
OBJ.update_status;

% refresh FILE, and record MOFO

% add buttons for:  (1) updating tags (2) doing buffer stuff

set(tdt_figure,'visible','on');
