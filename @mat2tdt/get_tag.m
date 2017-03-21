function VAL=get_tag(OBJ,TAG)
%
%
%
%

OBJ.update_tags;

if isfield(OBJ.tags,TAG)
  VAL=OBJ.tags.(TAG)
end
