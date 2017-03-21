function NUM=get_device_number(ID)
%
%
%
%

table={'pa5',33,'rp2',35,'rl2',36,...
	'ra16',37,'rv8',39,'rx5',45,'rx6',46,...
	'rx7',47,'rx8',48,'rz2',50,'rz5',53,'rz6',54};

hit=find(strcmp(table,lower(ID)));

if ~isempty(hit)
	NUM=table{hit+1};
else
	NUM=[];
end
