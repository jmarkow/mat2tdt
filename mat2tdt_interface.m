function mat2tdt_interface(varargin)
%
%
%
%


% user parameters

hw='rx8';
interface='USB';
num=1;
box_width=.5;
text_width=.3;
vert_space=.025;
fontsize=13;
cof='';

nparams=length(varargin);

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

for i=1:2:nparams
	switch lower(varargin{i})
		case 'hw'
			hw=varargin{i+1};
		case 'interface'
			interface=varargin{i+1};
		case 'num'
			num=varargin{i+1};
		case 'box_width'
		  	box_width=varargin{i+1};
		case 'text_width'
			text_width=varargin{i+1};
		case 'vert_space'
			vert_space=varargin{i+1}:
		case 'fontsize'
			fontsize=varargin{i+1};

	end
end

% gathers tags and provides a simple interface to change them

if isempty(cof)
	[pathname,filename]=uigetfile('*.rcx','Pick a circuit file to load, must match the currently running circuit');
end

% connect to the tdt

dev=mat2tdt_connect(hw,interface,num);

% get parameter tag names and properties

tags=mat2tdt_collect_tags(dev);

to_del=[];

for i=1:length(tags)
	if tags(i).size~=1
		to_del=[to_del i];
	end
end

tags(to_del)=[];

% loop through tags and set up interface

ntags=length(tags);

top_pos=.95;
bottom_pos=.1;

px_space=top_pos-bottom_pos;
vert_space_tot=vert_space*ntags;

rem_space=px_space-vert_space;
box_height=rem_space/ntags;

tdt_figure=figure('Visible','off','Name',['TDT interface v.001a'],...
	'Position',[200,200,300,min(50*ntags,800)],'NumberTitle','off',...
	'menubar','none','resize','on');

tag_axis=[];

curr_pos=top_pos;

for i=1:ntags

	% start at top
	% callback is to reset the tag if we edit the text

	name_axis(i)=uicontrol(tdt_figure,'Style','text',...
		'String',tags(i).name,...
		'Units','Normalized',...
		'FontSize',fontsize,...
		'Position',[.05 curr_pos-box_height text_width box_height/2]); 

	pos=get(name_axis(i),'position');

	tag_axis(i)=uicontrol(tdt_figure,'Style','edit',...
		'String',num2str(tags(i).val),...
		'Units','Normalized',...
		'FontSize',fontsize,...
		'Position',[pos(1)+pos(3)+.05 curr_pos-box_height box_width box_height],...
		'Call',{@mat2tdt_set_tag,dev,tags(i).name});

	curr_pos=curr_pos-box_height-vert_space;

end

set(tdt_figure,'visible','on');

% TODO: cleanup functions?
% TODO: leave room for soft triggers, displays for buffers?
