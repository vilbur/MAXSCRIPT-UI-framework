clearListener(); print("Cleared in: "+getSourceFileName())



file_path = @"C:\Users\vilbur\AppData\Local\Autodesk\3dsMax\2023 - 64bit\ENU\scripts\MAXSCRIPT-UI-framework\Lib\JsonToDictionoray\JsonToDictionoray.ms"

content = ""

if (file = openFile file_path mode:"rt") != undefined then
(
    while not eof file do
        content += (readLine file + "\n")

    close file
)

print content



--if (file = openFile file_path mode:"rt") != undefined then
--(
--    while not eof file do
--    (
--        content += (readLine file + "\n")
--    )
--    close file
--)
--
--print content