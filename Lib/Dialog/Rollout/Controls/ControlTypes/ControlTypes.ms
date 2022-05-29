/** [All control types available in maxscript UI ](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
 */
struct ControlTypes_v
(
	/**  COMMENTED TYPES ARE NOT SUPPORTED
	  */
	list = #(
		#Label,
		#Button,
		#Checkbox,
		#CheckButton,
		#Spinner,
		#Edittext,
		#Listbox,
		#MultiListBox,
		#Dropdownlist,
		#GroupBox,
		#Combobox,
		--#Angle,
		--#Bitmap,
		#ColorPicker,
		--#hyperlink,
		--#imgTag,
		--#Mapbutton,
		--#Materialbutton,
		#PickButton,
		--#ProgressBar,
		#Slider,
		--#Curve,	-- DOES NOT WORK YET
		--#popupMenu,	-- DOES NOT WORK YET
		#RadioButtons,	-- DOES NOT WORK YET
		#Timer,
		
		/* CUSTOM CONTROL TYPES */ 
		#browsePath
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