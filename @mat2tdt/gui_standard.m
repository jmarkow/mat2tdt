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
panel_background=[0 0 0];
font_color=[1 1 1];
figure_background=[0 0 0];

fontsize=10;
status_bar_height=.1;
column_margin=.01;
hor_margin=.025;
vert_margin=.01;
panel_vert_margin=.01;
panel_hor_margin=.05;
tag_top_pos=1-vert_margin;
tag_bottom_pos=.45;

if OBJ.status.buffer_exists
    metadata_width=.3;
else
    metadata_width=0;
end

ncols=ceil(ntags/OBJ.settings.gui_rows_per_column);
column_width=(OBJ.settings.gui_width-50)/ncols;

tdt_figure=figure('Visible','off','Name',['TDT interface v.001a'],...
	'Position',[50,50,OBJ.settings.gui_width,...
    min(OBJ.settings.gui_row_height*ntags,OBJ.settings.gui_height)],...
	'NumberTitle','off',...
	'menubar','none','resize','on','Color',figure_background);

tag_axis=struct();
name_axis=struct();


tag_width=(1-metadata_width)-hor_margin*2;
column_width=(1-panel_hor_margin*2)/ncols;
cur_pos=top_pos;

column_width=(1-panel_hor_margin*2)/ncols;
text_width=column_width*.5;
edit_width=column_width-text_width;
box_height=(1-panel_vert_margin*2)/OBJ.settings.gui_rows_per_column;

panel_tag=uipanel(tdt_figure,'Title','Tags',...
      'Units','Normalized',...
      'Position',[ hor_margin tag_bottom_pos tag_width tag_top_pos-tag_bottom_pos],...
      'BackgroundColor',panel_background,...
      'ForegroundColor',font_color,'FontSize',fontsize);

for i=1:ntags

	% start at top
	% callback is to reset the tag if we edit the text

	cur_column=floor((i-1)/OBJ.settings.gui_rows_per_column);
    cur_row=rem(i-1,OBJ.settings.gui_rows_per_column)+1;

	left_edge=cur_column*column_width+column_margin*min(cur_column+1,1);

	name_axis.(tag_names{i})=uicontrol(panel_tag,'Style','text',...
		'String',tag_names{i},...
		'Units','Normalized',...
		'FontSize',fontsize,...
		'Position',[left_edge (1-panel_vert_margin)-box_height*cur_row text_width box_height/2],...
        'BackgroundColor',panel_background,....
        'ForegroundColor',font_color);

	pos=get(name_axis.(tag_names{i}),'position');

	tag_axis.(tag_names{i})=uicontrol(panel_tag,'Style','edit',...
		'String',OBJ.tags.(tag_names{i}),...
		'Units','Normalized',...
		'FontSize',fontsize,...
		'Position',[left_edge+text_width (1-panel_vert_margin)-box_height*cur_row edit_width box_height/2]);


end

OBJ.gui_handles.tags=tag_axis;
rem_top=bottom_pos-(status_bar_height+vert_margin);
button_height=(1-panel_vert_margin*2)/3;
button_width=(1-panel_hor_margin*2);

panel_control=uipanel(tdt_figure,'Title','Device control',...
      'Units','Normalized',...
      'Position',[ hor_margin vert_margin+status_bar_height .3 bottom_pos-(vert_margin+status_bar_height) ],...
      'BackgroundColor',panel_background,...
      'ForegroundColor',font_color,'FontSize',fontsize);

button_axis.update_tags=uicontrol(panel_control,'Style','PushButton',...
	'String',sprintf('Push tags to %s',OBJ.settings.dev),...
	'Units','Normalized',...
	'FontSize',fontsize,...
	'Position',[ panel_hor_margin 1-button_height button_width button_height/1.25 ],...
	'Call',{@push_tags_gui,OBJ,tag_axis});

button_axis.run_circuit=uicontrol(panel_control,'Style','PushButton',...
	'String','Run',...
	'Units','Normalized',...
	'FontSize',fontsize,...
	'Position',[ panel_hor_margin 1-button_height*2 button_width button_height/1.25 ],...
	'Call',{@run_circuit_gui,OBJ});

button_axis.halt_circuit=uicontrol(panel_control,'Style','PushButton',...
	'String','Halt',...
	'Units','Normalized',...
	'FontSize',fontsize,...
	'Position',[ panel_hor_margin 1-button_height*3 button_width button_height/1.25 ],...
	'Call',{@halt_circuit_gui,OBJ});


panel_status=uipanel(tdt_figure,'Title','Device status',...
      'Units','Normalized',...
      'Position',[ hor_margin vert_margin .95 status_bar_height ],...
      'BackgroundColor',panel_background,...
      'ForegroundColor',font_color,'FontSize',fontsize);

status_bar={'circuit_loaded','circuit_running','sampling_rate','recording_enabled'};
status_width=(1-panel_hor_margin*2)/length(status_bar);
text_width=status_width*.7;
indication_width=status_width-text_width;

for i=1:length(status_bar)

	% format

	status_id=sprintf('%s_text',status_bar{i});
	status_text=sprintf('%s: ',regexprep(status_bar{i},'_',' '));
	status_text(1)=upper(status_text(1));

	status_axis.(status_id)=uicontrol(panel_status,'Style','text',...
			'String',status_text,...
			'Units','Normalized',...
            'BackgroundColor',panel_background,...
            'ForegroundColor',font_color,...
            'FontSize',10,...
			'Position',[status_width*(i-1) panel_vert_margin text_width .95]);

	status_axis.(status_bar{i})=uicontrol(panel_status,'Style','text',...
			'String','',...
			'Units','Normalized',...
            'BackgroundColor',panel_background,...
            'ForegroundColor',font_color,...
            'FontWeight','bold',...
            'FontSize',10,...
            'HorizontalAlignment','left',...
			'Position',[status_width*(i-1)+text_width panel_vert_margin indication_width .95]);

end

% alright add an effin' record buffer button bar


if OBJ.status.buffer_exists

	metadata_fields=fieldnames(OBJ.metadata);
	metadata_fields={'session_name','subject_name','notes'};

	file_height=1/4;
	button_height=1-file_height;

	pos=get(panel_control,'position');

	panel_buffer=uipanel(tdt_figure,'Title','Buffer control',...
		'Units','Normalized',...
		'Position',[ pos(1)+pos(3)+hor_margin pos(2) (1-hor_margin*2-(pos(1)+pos(3))) pos(4) ],...
		'BackgroundColor',panel_background,...
		'ForegroundColor',font_color,...
		'FontSize',fontsize);

	button_axis.buffer_filename=uicontrol(panel_buffer,'Style','Text',...
		'String',OBJ.buffer_store,...
		'Units','Normalized',...
		'BackgroundColor',panel_background,...
		'ForegroundColor',font_color,...
		'FontSize',fontsize,...
		'Position',[panel_hor_margin+.11 (1-panel_vert_margin-file_height) (1-panel_hor_margin*2) file_height/1.5 ]);

	button_axis.get_new_file=uicontrol(panel_buffer,'Style','Pushbutton',...
		'String','Auto',...
		'Units','Normalized',...
		'Position',[panel_hor_margin (1-panel_vert_margin-file_height) .1 file_height/1.5 ],...
		'Callback',{@set_buffer_store_gui,OBJ});

	% TODO: add callback

	button_axis.get_new_file_dialog=uicontrol(panel_buffer,'Style','Pushbutton',...
		'String','...',...
		'Units','Normalized',...
		'Position',[panel_hor_margin+.1 (1-panel_vert_margin-file_height) .1 file_height/1.5 ]);

	button_axis.stop_button=uicontrol(panel_buffer,'Style','Pushbutton',...
		'String','Stop buffer',...
		'Units','Normalized',...
		'Position',[panel_hor_margin+.25 (1-panel_vert_margin-file_height/1.5-button_height) .2 button_height/2 ],...
		'Callback',{@stop_recording_gui,OBJ},'enable','off');

	pos=get(panel_tag,'position');

	panel_metadata=uipanel(tdt_figure,'Title','Buffer metadata',...
		'Units','Normalized',...
		'Position',[ pos(1)+pos(3)+hor_margin pos(2) (1-hor_margin*2-(pos(1)+pos(3))) pos(4) ],...
		'BackgroundColor',panel_background,...
		'ForegroundColor',font_color,...
		'FontSize',fontsize);

	nfields=length(metadata_fields);
	row_height=(1-panel_vert_margin*2)/(nfields*2);
	text_width=(1-panel_hor_margin*2);
	edit_width=(1-panel_hor_margin*2);
	row_idx=0;

	% write these out to a metadata property and I think we're done you
	% lovely man

	for j=1:nfields

		% start at top
		% callback is to reset the tag if we edit the text

		row_idx=row_idx+1;
		cur_row=rem(row_idx-1,6)+1;

		metadata_id=sprintf('%s_text',metadata_fields{j});
		metadata_text=sprintf('%s: ',regexprep(metadata_fields{j},'_',' '));
		metadata_text(1)=upper(metadata_text(1));

		[panel_hor_margin (1-panel_vert_margin)-row_height*cur_row text_width row_height/2]

		metadata_axis.(metadata_id)=uicontrol(panel_metadata,'Style','text',...
			'String',metadata_text,...
			'FontSize',fontsize,...
			'Unit','Normalized',...
			'Position',[panel_hor_margin (1-panel_vert_margin)-row_height*cur_row text_width row_height/2],...
			'BackgroundColor',panel_background,....
			'ForegroundColor',font_color);

		row_idx=row_idx+1;
		cur_row=rem(row_idx-1,6)+1;

		metadata_axis.(metadata_fields{j})=uicontrol(panel_metadata,'Style','edit',...
			'String','',...
			'Units','Normalized',...
			'FontSize',fontsize,...
			'Max',2,...
			'Position',[panel_hor_margin (1-panel_vert_margin)-row_height*cur_row edit_width row_height],...
			'Callback',{@update_metadata_gui,OBJ,metadata_fields{j}});


	end

	OBJ.gui_handles.button=button_axis;
	OBJ.gui_handles.status=status_axis;

	button_axis.record_buffer=uicontrol(panel_buffer,'Style','Pushbutton',...
		'String','Start buffer',...
		'Units','Normalized',...
		'Position',[panel_hor_margin (1-panel_vert_margin-file_height/1.5-button_height) .2 button_height/2 ],...
		'Callback',{@recording_loop_gui,OBJ},...
		'UserData',true);


end

OBJ.gui_handles.status=status_axis;
OBJ.gui_handles.button=button_axis;
OBJ.update_status;

% refresh FILE, and record MOFO

% add buttons for:  (1) updating tags (2) doing buffer stuff

set(tdt_figure,'visible','on');
