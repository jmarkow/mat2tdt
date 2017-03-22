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

OBJ.collect_tags;
SUCCEED=false;
EPS=1e-6;
if isfield(OBJ.tags,TAG)

  tag_class=class(OBJ.tags.(TAG));
  use_class=class(VAL);

  if isa(VAL,use_class)
    fprintf('Setting tag %s ',TAG)
    if isnumeric(VAL)
      fprintf('to %g...',VAL);
    else
      fprintf('to %s...',VAL);
    end

    oldval=OBJ.activex.dev.GetTagVal(TAG);
    use_class=class(TAG);

    SUCCEED=OBJ.activex.dev.SetTagVal(TAG,VAL);

    % get the tag dun dun dun

    newval=OBJ.activex.dev.GetTagVal(TAG);

    if isnumeric(newval)
      if abs(newval-VAL)<=EPS & SUCCEED
        fprintf('succeeded\n');
      else
        fprintf('failed, current value %g\n',newval)
      end
    elseif ~SUCCEED
        fprintf('failed, current value %s\n',newval);
    end

  else
    fprintf('Skipping %s, used class %s but correct class is %s\n',...
      TAG,tag_class,use_class);
  end
else
  fprintf('Did not find tag %s\n',TAG)
end

OBJ.collect_tags;
