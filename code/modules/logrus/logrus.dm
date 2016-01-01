/obj/effect/proc_holder/logrus/probe
	name = "Logrus Sprout"
	desc = "Yellow glowing transparent thing it the air"
	icon = 'icons/effects/magic.dmi'
	icon_state = "logrus"
	w_class = 10.0
	layer = 20
	density = 0
	anchored = 1
	var/atom/movable/focus = null
	var/mob/living/host = null
	var/canmove = 1

/obj/effect/proc_holder/logrus/probe/verb/activate()
	set name = "Activate"





/obj/item/logrus
	name = "Logrus Sprout"
	desc = "Yellow glowing transparent thing it the air"
	icon = 'icons/effects/magic.dmi'
	icon_state = "logrus"

	equipped(var/mob/user, var/slot)
		if( (slot == slot_l_hand) || (slot== slot_r_hand) )	return
		del(src)
		return