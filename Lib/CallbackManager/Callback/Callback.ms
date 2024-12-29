/** Keep data of callback
  *
  */
struct Callback_v
(
	callback,	-- function called on event
	type,	-- event type
	id,	-- callback id, can be sahre acrros mutliple callbacks

	on create do
	(
	)
)