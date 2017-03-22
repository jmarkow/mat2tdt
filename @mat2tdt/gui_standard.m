function gui_standard(OBJ)
%
%
%


if ~OBJ.status.circuit_loaded
	fprintf('Need to load a circuit first...\n');
	return;
end

OBJ.update_status;
OBJ.collect_tags;

tag_names=fieldnames(OBJ.tags);
ntags=length(tag_names);

fontsize=10;
top_pos=.95;
bottom_pos=.3;
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
    
	left_edge=cur_column*column_width+.05*min(cur_column,1);

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
		%'Call',{@mat2tdt_set_tag,dev,tags(i).name});

	cur_pos=cur_pos-box_height-.01;

end

tag_axis.update_tags=uicontrol(tdt_figure,'Style','PushButton',...
	'String',sprintf('Push tags to %s',OBJ.settings.dev),...
	'Units','Normalized',...
	'FontSize',fontsize,...
	'Position',[.05 .15 .3 .1]);

% add buttons for:  (1) updating tags (2) doing buffer stuff

set(tdt_figure,'visible','on');
