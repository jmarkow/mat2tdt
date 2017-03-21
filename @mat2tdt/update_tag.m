function SUCCEED=update_tag(OBJ,TAG,VAL)
% Sets paramtag and validates that everything worked as expected
%
%

if nargin<3
  error('Need tag name and settings to continue');
end

if ~OBJ.status.circuit_loaded
  fprintf('Circuit must be loaded before setting tags\n');
  return
end

OBJ.update_tags;
SUCCEED=false;

if isfield(OBJ.tags,TAG)

  tag_class=classname(OBJ.tags.(TAG));
  use_class=classname(VAL);

  if isa(VAL,use_class)
    fprintf('Setting tag %s ',TAG)
    if isnumeric(VAL)
      fprintf('to %g...',VAL);
    else
      fprintf('to %s...',VAL);
    end

    SUCCEED=OBJ.actxcontrol.SetTagVal(TAG,VAL);

    % get the tag dun dun dun

    newval=OBJ.actxcontrol.GetTagVal(TAG);

    if newval==VAL & SUCCEED
      fprintf('succeeded\n');
    else
      if isnumeric
        fprintf('failed, new value %g\n',newval)
      else
        fprintf('failed, new value %s\n',newval);
      end
    end
  else
    fprintf('Skipping %s, used class %s but correct class is %s\n',...
      TAG,tag_class,use_class);
  end
else
  fprintf('Did not find tag %s\n',TAG)
end

OBJ.update_tags;
