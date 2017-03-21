function run_circuit(OBJ)
%
%
%

if ~OBJ.status.circuit_loaded
	fprintf('Must load circuit first.\n');
	return;
end

OBJ.activex.dev.Run;
OBJ.update_status;
