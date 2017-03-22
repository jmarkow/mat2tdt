function set_options_from_file(OBJ,FILE);
% Makes sure the user sets options correctly
%
%
%

struct=read_options(FILE);
categories=fieldnames(struct);

% first settings, then tags

if isfield(struct,'settings')
	options=fieldnames(struct.settings);
	for i=1:length(options)
		if isfield(OBJ.settings,options{i})
			use_class=class(OBJ.settings.(options{i}));
			if isa(struct.settings.(options{i}),use_class)
				OBJ.settings.(options{i})=struct.settings.(options{i});
			else
				fprintf('Skipping %s, used class %s but correct class is %s\n',...
					(options{i}),use_class,classname(struct.settings.(options{i})));
			end
		else
			fprintf('Did not find setting %s\n',options{i});
		end
	end
end

OBJ.update_status;

% re-initialize before setting tags?? get tag value to validate class first????
% we can only do this if a circuit is loaded

if isfield(struct,'tags')

	if ~OBJ.status.circuit_loaded
		OBJ.load_circuit;
		if ~OBJ.status.circuit_loaded
			fprintf('Could not load circuit\n');
			return;
		end
	end

	options=fieldnames(struct.tags);
	for i=1:length(options)
		OBJ.update_tag(options{i},struct.tags.(options{i}));
	end
end

% other options, how to handle?
