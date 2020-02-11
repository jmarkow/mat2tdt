function update_metadata_gui(SRC,EVENT,OBJ,FIELD)
% update the appropriate field
%
%
%

fprintf('Updating metadata field %s...',FIELD);
if isfield(OBJ.metadata,FIELD)
    OBJ.metadata.(FIELD)=get(SRC,'String');
    fprintf('success\n');
else
    fprintf('could not find field\n');
end
