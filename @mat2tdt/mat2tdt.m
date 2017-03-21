classdef mat2tdt < handle & matlab.mixin.SetGet
	% implements a convenience class for dealing with TDT hardware
	% this won't do everything, but it will do something, I promise

	properties

		device
		circuit
		fs
		actxcontrol

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

		function obj=mat2tdt(OPTIONS,DEV,COF,FS)

			% read the defaults, try to make something of it

			if nargin<4
				FS=[];
			end

			if nargin<3
				COF=[];
			end

			if nargin<2
				DEV=[];
			end

			if nargin<1
				OPTIONS=[];
			end

			if ~isempty(DEV)
				obj.settings.device=DEV;
			end

			if ~isempty(COF)
				obj.settings.circuit_file=COF;
			end

			if ~isempty(FS)
				obj.settings.circuit_fs=FS;
			end

			obj.connect_activex;

			if ~isempty(OPTIONS)
				obj.set_options_from_file(OPTIONS);
			end

			obj.update_status;

		end

		% setting any of these options triggers a status update

		function obj = set.flip_model(obj,val)
			if isa(val,'CompactTreeBagger')
				obj.flip_model=val;
				obj.options.flip.method='m';
				obj.update_status;
			elseif ischar(val)
				if exist(val,'file')
					obj.set_file('flip_model',val);
					obj.options.flip.method='m';
					obj.update_status;
				end
			end
		end

		function obj = set.has_cable(obj,val)
			if isa(val,'logical') | isnumeric(val)
				obj.has_cable=logical(val);
				if val==true
					obj.use_tracking_model=true;
				end
				obj.update_status;
			end
		end

		function obj = set.use_tracking_model(obj,val)
			if isa(val,'logical') | isnumeric(val)
				obj.use_tracking_model=logical(val);
				obj.update_status;
			end
		end

		function obj = set.working_dir(obj,val)
			% check if dir exists
			if exist(val,'dir')>0
				obj.working_dir=val;
				obj.update_status;
			end
		end

		function obj = set.metadata(obj,val)
			if isstruct(val)
				if isfield(val,'extract')
					if isfield(val.extract,'SubjectName')
						obj.mouse_id=val.extract.SubjectName;
					end
				end
			end
			obj.metadata=val;
		end

		function s = saveobj(obj)
			s.projections=obj.projections;
			s.options=obj.options;
			s.pca=obj.pca;
			s.files=obj.files;
			s.behavior_model=obj.behavior_model;
			s.working_dir=obj.working_dir;
			s.average_image=obj.average_image;
			s.neural_data=obj.neural_data;
			s.timestamps=obj.timestamps;
			s.metadata=obj.metadata;
			s.transform=obj.transform;
		end

		function phot_obj = get_photometry(obj,force)

			if nargin<2
				force=false;
			end

			for i=length(obj):-1:1

				if isfield(obj(i).neural_data,'photometry') & ~force
					if isa(obj(i).neural_data.photometry,'photometry')
						phot_obj(i)=obj(i).neural_data.photometry;
					end
					continue;
				end

				if ~isfield(obj(i).metadata,'nframes')
					obj(i).load_timestamps;
				end

				if ~isfield(obj(i).metadata,'extract')
					obj(i).load_metadata;
				end

				if obj(i).files.nidaq{2}
					[data,ts]=obj(i).load_nidaq;
					phot_obj(i)=photometry(data,ts,obj(i).metadata.extract.NidaqChannelNames);
					obj(i).neural_data.photometry=phot_obj(i);
					phot_obj(i).change_timebase(obj(i).timestamps.depth(:,2));
				end

			end

			obj.update_status;

		end

		function beh_obj = get_behavior_model(obj)
			for i=1:length(obj)
				beh_obj(i)=obj(i).behavior_model;
			end
		end


	end

	methods(Static)

	% doesn't require the kinect_extract object

	end

end
