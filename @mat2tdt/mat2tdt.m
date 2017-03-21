classdef mat2tdt < handle & matlab.mixin.SetGet
	% implements a convenience class for dealing with TDT hardware
	% this won't do everything, but it will do something, I promise

	properties

		device
		circuit
		fs
		activex

	end

	properties (GetAccess=public,SetAccess=private)

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
			obj.use_defaults;

			if ~isempty(OPTIONS)
				obj.set_options_from_file(OPTIONS);
			end

			obj.connect_activex;


		end

		% setting any of these options triggers a status update

	end

	methods(Static)

	% doesn't require the kinect_extract object

	end

end
