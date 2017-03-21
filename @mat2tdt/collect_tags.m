function collect_tags(OBJ)
% Gets all partags in the loaded circuit and maps to the object
%
%

if ~OBJ.status.circuit_loaded
	fprintf('Circuit not loaded yet.\n');
	return;
end

num=OBJ.activex.dev.GetNumOf('ParTag');

for i=1:num
	tag_name=OBJ.activex.dev.GetNameOf('ParTag',i);
	OBJ.tags.(tag_name)=OBJ.activex.dev.GetTagVal(tag_name);
end
