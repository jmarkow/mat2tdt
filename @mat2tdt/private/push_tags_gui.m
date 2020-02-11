function push_tags_gui(SRC,EVENT,OBJ,TAG_HANDLES)
%
%
%
%

EPS=1e-6;
tag_names_gui=fieldnames(TAG_HANDLES);
tag_names_set=fieldnames(OBJ.tags);

for i=1:length(tag_names_gui)
    if isfield(OBJ.tags,tag_names_gui{i})
        tmp_val=str2num(get(TAG_HANDLES.(tag_names_gui{i}),'String'));
        if abs(OBJ.tags.(tag_names_gui{i})-tmp_val)>=EPS
            OBJ.update_tag(tag_names_gui{i},tmp_val);
        end
    end
end

OBJ.update_status;
