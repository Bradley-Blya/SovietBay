/obj/logrus/effect/auxilary/trigger
	//type "mental", "gesture", "point", "[signal]", "[scanner]"

/obj/logrus/effect/auxilary/trigger/cost()
	switch(type)
		if("select")
			cost = 2
		if("point_to")
			cost = 1
		if("mental")
			cost = 15
	cost += constraint

/obj/logrus/effect/auxilary/trigger/cast()
	source.Transfer(source, src, constraint)
	Discharge(waste)

/obj/logrus/effect/auxilary/trigger/point(mob/M, atom/A)
	if(type != "point")
		return

	Transfer(source, src, cost)

	if(mana >= constraint)
		DecreaseMana(cost)
		set_target(A)
		Destroy()
