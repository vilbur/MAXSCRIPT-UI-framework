filein( getFilenamePath(getSourceFileName()) + "/../Ini.ms" )

clearListener()

ini	= Ini_v()

strings = #(
	"true",
	"123",
	"1.0",
	"Sun",
	"[1.1,2.0]",
	"[1,2,3.3]",
	"color 1 2 3"
)

for _string in strings do
	format "\"%\" 	=> 	% 	% \n" _string (val = ini.convertDatatype _string) (classof val)