clearListener()

--isKeyDown = ( dotNetClass "managedservices.keyboard").isKeyDown
keys = dotNetClass "system.windows.forms.keys"

for key in (getPropNames keys) do
	format "key	= % \n" key
