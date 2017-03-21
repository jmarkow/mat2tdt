function halt(OBJ)
%
%
%

if ~OBJ.status.circuit_running
	fprintf('Circuit must be running to halt.\n');
	return;
end

OBJ.activex.dev.Halt;
