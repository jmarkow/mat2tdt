function load_circuit(OBJ)
%
%

if ~(OBJ.status.activex & OBJ.status.dev_connected & OBJ.status.circuit_exists)
	fprintf('Need activex connection, connected device, and valid COF\n');
	return;
end

loadfile_status=OBJ.activex.dev.LoadCOFsf(OBJ.settings.circuit_file,OBJ.settings.circuit_fs);

if loadfile_status==0
	error('Error loading circuit %s',OBJ.settings.circuit_file);
end

OBJ.collect_tags;
OBJ.update_status;
