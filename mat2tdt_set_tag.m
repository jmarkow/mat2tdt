function mat2tdt_set_tag(OBJ,EVENT,DEV,TAG_NAME)
%
%
%
%

newval=str2num(get(OBJ,'string'));
status=DEV.SetTagVal(TAG_NAME,newval);

if status
	fprintf('Set parameter %s to %g\n',TAG_NAME,newval);
else
	fprintf('Error setting parameter %s to %g\n',TAG_NAME,newval);
end
