function use_defaults(OBJ)
%
%
%
%

[pathname,~,~]=fileparts(mfilename('fullpath'));
def_options=fullfile(pathname,'defaults.config');
struct=read_options(def_options);
categories=fieldnames(struct.settings);

for i=1:length(categories)
	OBJ.settings.(categories{i})=struct.settings.(categories{i});
end
