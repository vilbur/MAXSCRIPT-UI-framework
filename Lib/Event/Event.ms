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
	/* EVENT PROPERTIES */
	type     = #PRESSED,
	params	= "", -- E.g.: "val inCancel" -- params used for event definition

	/* CALLBACK PROPERTIES */
	callback	= "", -- code called when event is fired
	arguments	= "", -- arguments passed to callback

	/* OTHER PROPERTIES */
	tooltip	= "", -- tooltip for callback
	autorun	= false
)