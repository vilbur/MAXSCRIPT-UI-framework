/** [ALL CONTROL TYPES available in maxscript UI ](https://help.autodesk.com/view/MAXDEV/2021/ENU/?guid=GUID-E421933F-958E-42FD-80A1-D66F2A2C0A06)
  
  List of available control for framework
  
  @param name control_type
  
  @return boolean of test if control type exists and control_type is DEFINED
 
  @return array  of control types if control_type is UNDEFINED
  
	E.G.:
		ControlTypes_v( #BUTTON ) > return true
		ControlTypes_v( #FOOBAR ) > retrun false
  
 */
struct ControlTypes_v
(
	/* construct */ 

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
		#Angle,
		#Bitmap,
		#ColorPicker,
		#hyperlink,
		#imgTag,
		#Mapbutton,
		#Materialbutton,
		#PickButton,
		#ProgressBar,
		#Slider,
		#RadioButtons,
		#Curve,	-- DOES NOT WORK YET
		#popupMenu,	-- DOES NOT WORK YET
		#Timer,

		/* CUSTOM CONTROL TYPES */
		#browsePath
	),
	
	/** Exists
	 */
	function exists control_type =
	(
		--format "\n"; print "ControlTypes_v.exists()"
		--print("ControlTypes_v.onCreate()")
		--format "control_type: %\n" control_type
		----format "TEST: %\n" (findItem this.list	control_ty1pe > 0)
		--if control_type != undefined then
			findItem this.list	control_type > 0 --return
			
		--else
		--	this.list --return
		--	
		--	true --return		
		
	),
	
	--/** Get all types
	-- */
	--function getAllTypes =
	--(
	--	list --return
	--),
	
	private
	
	/** return boolean of test if control type exists
	 */
	on create do
	(

	)
)