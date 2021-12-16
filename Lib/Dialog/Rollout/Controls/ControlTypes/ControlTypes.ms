/** [All control types available in maxscript UI ](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
 */
struct ControlTypes_v
(
	/**  
	  */
	list = #(
		#Label,
		#Button,
		#Checkbox,
		#Checkbutton,
		#Spinner,
		#Edittext,
		#Listbox,
		#multilistbox,
		#Dropdownlist,
		#GroupBox,
		--#Combobox,
		--#Angle,
		--#Bitmap,
		--#Colorpicker,
		--#hyperlink,
		--#imgTag,
		--#Mapbutton,
		--#Materialbutton,
		--#Pickbutton,
		--#ProgressBar,
		--#Slider,
		--#Curve,	-- DOES NOT WORK YET
		--#popupMenu,	-- DOES NOT WORK YET
		--#Radiobuttons,	-- DOES NOT WORK YET
		#Timer
	),

	/** Get all types
	 */
	function getAllTypes =
	(
		list --return
	),

	private
	
	/**;  
	 */
	on create do
	(
		--print("ControlTypes_v.onCreate()")
	)
)