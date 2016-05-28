/obj/item/weapon/reagent_containers/glass/bucket/attackby(var/obj/item/weapon/gutsy_chip/S, mob/user as mob)
	..()
	if(type != /obj/item/weapon/reagent_containers/glass/bucket)
		return
	qdel(S)
	var/obj/item/weapon/gutsy_assembly/A = new /obj/item/weapon/gutsy_assembly
	user.put_in_hands(A)
	user << "You add the signaler to the helmet."
	user.drop_from_inventory(src)
	qdel(src)
	return
//----------------------------------------------------------------------
/obj/item/weapon/gutsy_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"
	var/build_step = 0
	var/created_name = "Securitron"

/obj/item/weapon/gutsy_assembly/attackby(var/obj/item/O, var/mob/user)
	..()
	if(istype(O, /obj/item/weapon/weldingtool) && !build_step)
		var/obj/item/weapon/weldingtool/WT = O
		if(WT.remove_fuel(0, user))
			build_step = 1
			overlays += image('icons/obj/aibots.dmi', "hs_hole")
			user << "You weld a hole in \the [src]."

	else if(isprox(O) && (build_step == 1))
		user.drop_item()
		build_step = 2
		user << "You add \the [O] to [src]."
		overlays += image('icons/obj/aibots.dmi', "hs_eye")
		name = "helmet/signaler/prox sensor assembly"
		qdel(O)

	else if((istype(O, /obj/item/robot_parts/l_arm) || istype(O, /obj/item/robot_parts/r_arm)) && build_step == 2)
		user.drop_item()
		build_step = 3
		user << "You add \the [O] to [src]."
		name = "helmet/signaler/prox sensor/robot arm assembly"
		overlays += image('icons/obj/aibots.dmi', "hs_arm")
		qdel(O)

	else if(istype(O, /obj/item/weapon/melee/baton) && build_step == 3)
		user.drop_item()
		user << "You complete the Securitron! Beep boop."
		var/mob/living/bot/gutsy/S = new /mob/living/bot/gutsy(get_turf(src))
		S.name = created_name
		qdel(O)
		qdel(src)

	else if(istype(O, /obj/item/weapon/pen))
		var/t = sanitizeSafe(input(user, "Enter new robot name", name, created_name), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return
		created_name = t
//----------------------------------------------------------------------
// End of file gutsy_construction.dm //---------------------------------
//----------------------------------------------------------------------