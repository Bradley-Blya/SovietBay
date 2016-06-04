
/mob/living/bot/gutsy/attackby(var/obj/item/O, var/mob/user)
	if(O.GetID())
		if(access_scanner.allowed(user) && !open && !emagged)
			locked = !locked
			user << "<span class='notice'>Controls are now [locked ? "locked." : "unlocked."]</span>"
			attack_hand(user)
		else
			if(emagged)
				user << "<span class='warning'>ERROR</span>"
			if(open)
				user << "<span class='warning'>Please close the access panel before locking it.</span>"
			else
				user << "<span class='warning'>Access denied.</span>"
		return
	else if(istype(O, /obj/item/weapon/screwdriver))
		if(!locked)
			open = !open
			user << "<span class='notice'>Maintenance panel is now [open ? "opened" : "closed"].</span>"
		else
			user << "<span class='notice'>You need to unlock the controls first.</span>"
		return
	else if(istype(O, /obj/item/weapon/weldingtool))
		if(health < maxHealth)
			if(open)
				health = min(maxHealth, health + 10)
				user.visible_message("<span class='notice'>[user] repairs [src].</span>","<span class='notice'>You repair [src].</span>")
			else
				user << "<span class='notice'>Unable to repair with the maintenance panel closed.</span>"
		else
			user << "<span class='notice'>[src] does not need a repair.</span>"
		return
	else
		..()

/mob/living/bot/gutsy/attack_ai(var/mob/user)
	return attack_hand(user)