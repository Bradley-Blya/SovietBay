/obj/logrus/proc/mana()
	var/started = world.timeofday
	var/chargedtime
	var/y
	var/x
	while(1)
		sleep(1)
		y = (x**1.469)/150+1
		if(y < 0.1)
			continue
		if(mana < 0.1)
			mana = 0
			continue
		y = round(y,0.001)
		mana -= y
		chargedtime = (world.timeofday - started)
		world << "[y]---[mana]---[chargedtime]"

/obj/logrus/spellcraft/mana()//
	var/started = world.timeofday
	var/chargedtime

	var/manainc
	while(1)
		sleep(1)
		if(stage)
			continue

		manainc = M() + K() + L()
		if(manainc < 0.1)
			continue
		manainc = round(manainc,0.001)
		mana += manainc

		chargedtime = (world.timeofday - started)
		world << "[manainc]---[mana]---[chargedtime]"

/obj/logrus/spellcraft
	proc/M()
		return (-(10*L()/(mana+5))**0.38)
	proc/K()
		return (-((0.014*mana)**2))
	proc/L()
		return 10

/obj/logrus/proc/consume(amt, t = 1)
	if(mana < amt)
		if(t)
			sip(amt -  mana)	//so we add the mana we need.
		amt = mana
		mana = 0
	else
		mana -= amt

	world << "[amt] consumed by [name]"
	return amt

/obj/logrus/proc/sip(amt, t = 0)
	if(!t)
		t = transfer_penalty(source)
	if(isspell(source))
		var/obj/logrus/spellcraft/S = source
		amt = t*S.consume(amt, 1)
	else
		for(var/obj/logrus/spellcraft/S in source)
			amt = t*S.consume(amt, 1)

	mana += amt
	return amt

/obj/logrus/proc/transfer(target, amt, t = 0)
	var/obj/logrus/T

	if(!t)
		t = transfer_penalty(target)

	if(isspell(target)) T = target
	else
		for(var/obj/logrus/spellcraft/l in target)
			T = l

	if(T)
		T.mana += t*consume(amt, 0)
		return 1

	return 0


/obj/logrus/proc/transfer_penalty(target)
	var r
	var penalty
	r = get_dist(src, target)

	switch(r)
		if(2 to 10)
			penalty = 1.5*r
		if(11 to 30)
			penalty = (1.3*(r+1))
		if(31 to 127)
			penalty = (1.3*(r+25) - 1.03*r)
		else return 0.5

	penalty = 1 - penalty/100
	return penalty




/*obj/effect/proc_holder/logrus/spellcraft/consume(amt, t)
	if(mana < amt)
		amt = mana
		mana = 0
	else
		mana -= amt

	world << "[amt] consumed by [name]"
	return amt*/

//F = L + M - K
//		manainc = (-((x-35)**2)/(91.7*x+1105)+1.5)
//(-(1000/(x+5))^0.38)-((0.014x)^2)+10