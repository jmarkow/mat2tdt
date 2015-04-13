function TAG=mat2tdt_collect_tags(DEV)
%
%

% get the number of tags

num=DEV.GetNumOf('ParTag');

for i=1:num
	TAG(i).name=DEV.GetNameOf('ParTag',i);
	TAG(i).type=char(DEV.GetTagType(TAG(i).name));
	TAG(i).size=DEV.GetTagSize(TAG(i).name);
	if TAG(i).size==1
		TAG(i).init_val=DEV.GetTagVal(TAG(i).name);
    end
end
