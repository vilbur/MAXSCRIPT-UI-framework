/** Event
  *
  * @property	name	type e.g.: #pressed
  * @property	string	callback
  * @property	string	tooltip
  * @property	string	params
  *
 */
struct Event_v
(
	type     = #pressed,
	params	= "",
	code     = "", -- REMOVE THIS
	callback = Dictionary #( #code, "" ) #( #arguments, "" ),
	tooltip	= "" -- tooltip for callback
)