classdef mat2tdt < handle & matlab.mixin.SetGet
	% implements a convenience class for dealing with TDT hardware
	% this won't do everything, but it will do something, I promise

	properties


	end

	properties (GetAccess=public,SetAccess=private)

		activex
		tags
		settings
		status

	end

	% the completely hidden stuff

	properties (Access=private)

	end

	% have the pca object be a constant object, instance should be shared
	% across an array of objects...

	methods

		function obj=mat2tdt(OPTIONS)

			if nargin<1
				OPTIONS=[];
			end

			% read the defaults, try to make something of it

			obj.settings.zbus_rack_num=[];
			obj.settings.zbus_address=[];

			obj.activex.zbus=[];
			obj.activex.dev=[];

			obj.use_defaults;
			obj.update_status;
			obj.connect_activex;

			config_files=dir(fullfile(pwd,'*.config'));

			if isempty(OPTIONS) & length(config_files)>0
				OPTIONS=fullfile(pwd,config_files(1).name);
			end

			if ~isempty(OPTIONS)
				obj.set_options_from_file(OPTIONS);
			end

		end

		% setting any of these options triggers a status update

	end

	methods(Static)

		num=get_device_number(id)

	% doesn't require the kinect_extract object

	end

end
