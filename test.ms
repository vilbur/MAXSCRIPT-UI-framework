clearListener(); print("Cleared in:\n"+getSourceFileName())

delete objects

b1 = box()
b2 = box()
b3 = box()

select objects


global WHEN_SELECT_CHANGED_OBJECTS = #()

/** When selection change
 */
function whenSelectionChange objs =
(
	if classOf objs == Array then
		join WHEN_SELECT_CHANGED_OBJECTS objs

	else
		append WHEN_SELECT_CHANGED_OBJECTS objs

	deleteAllChangeHandlers id:#WHEN_SELECT_CHANGED

	when select WHEN_SELECT_CHANGED_OBJECTS changes id:#WHEN_SELECT_CHANGED obj do
	(
		format "obj: %\n" obj
	)
)

whenSelectionChange( selection as Array )