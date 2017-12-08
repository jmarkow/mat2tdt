function set_buffer_status(OBJ,STATUS)
% make it short 'n sweet

if nargin<2 | isempty(STATUS)
    STATUS='null';
end

switch lower(STATUS(1))

case 'h'
  set_color='g';
  msg='healthy';
case 'u'
  set_color='r';
  msg='unhealthy';
otherwise
  set_color='w';
  msg='null';
end

set(OBJ.gui_handles.button.buffer_status,...
  'ForegroundColor',set_color,'String',sprintf('Buffer status: %s',upper(msg)));
