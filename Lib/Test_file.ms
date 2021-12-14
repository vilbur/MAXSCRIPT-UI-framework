
rollout a "Rollout A"
(
button a1 "a1"
on a resized val do (format "A: %\n" val)
)
--
rollout b "Rollout B"
(
	button b1 "b1" align:#left
	on b resized val do (format "B: %\n" val)
)
--
rof=newrolloutfloater "test" 200 200
addrollout a rof
addrollout b rof
rof.size=[300,300]