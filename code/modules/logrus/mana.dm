/obj/logrus/proc/Mana(var/ticks)
	return
/obj/logrus/effect/Mana()
	if(mana)
		perform()
	return
	/*var/started = world.timeofday
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
		worl
		d << "[y]---[mana]---[chargedtime]"*/

/obj/logrus/spellcraft
	var/started
	var/chargedtime

	var/manainc

/obj/logrus/spellcraft/Mana(var/ticks)
	if(ticks%10)
		return
	started = world.timeofday
	if(stage)
		return

	manainc = M() + K() + L()
	if(manainc < 0.1)
		return
	manainc = round(manainc,0.001)
	mana += manainc

	chargedtime = (world.timeofday - started)
	world << "[manainc]---[mana]---[chargedtime]" //testing purposes

/obj/logrus/spellcraft
	proc/M()
		return (-(1/L()*10000/(mana+5))**0.38)
	proc/K()
		return (-((0.014*mana)**2))
	proc/L()
		return 10
	proc/S()
		return

/obj/logrus/proc/SendMana(var/amt, var/xt, var/yt, var/receiver)
	var/TT = GetTargetTurf(src,xt,yt)
	if(!TT)
		world.log << "bad TT [world.time]"
		return
	TransferMana(src, TT, amt, receiver)

/obj/logrus/effect/targeted/SendMana(var/amt, var/xt = XT, var/yt = YT, var/receiver = target)
	..()

/proc/TransferMana(var/obj/logrus/sender, var/turf/T, var/amt, var/receiver, var/d = 1)
	if(!sender.mana)
		return

	amt = sender.DecreaseMana(amt)
	if(d)
		d = amt - amt * transfer_penalty(receiver)
		amt -= d
		//TransferEffects(target, waste)

	DispenceMana(T, amt, receiver)


/proc/DispenceMana(var/turf/T, var/amt, var/obj/logrus/REC)
	if(REC)
		if(T == GetTurfLoc(REC))
			REC.IncreaseMana(amt)
			return

	var/list/spells = list()
	spells = GetSeenSpells(T)
	if(!spells.len)
		Discharge(T, amt)
	else
		amt = amt/spells.len
		for(var/obj/logrus/S in spells)
			S.IncreaseMana(amt)





/obj/logrus/proc/DecreaseMana(var/amt)
	if(!mana)
		return 0

	if(mana < amt)
		amt = mana
		mana = 0
	else
		mana -= amt

	return amt

/obj/logrus/proc/IncreaseMana(var/amt)
	mana += amt

/proc/transfer_penalty(target)
	var r
	var penalty
	r = get_dist(src, target)

	switch(r)
		if(2 to 10)
			penalty = 1.5*r
		if(11 to 30)
			penalty = (1.3*(r+1))
		if(31 to 999)
			penalty = (1.3*(r+25) - 1.03*r)
		else return 0.5

	penalty = 1 - penalty/100
	return penalty


/proc/Discharge(var/turf/T, var/amt)
	empulse(src, 1, 0)

/*/obj/logrus/proc/transfer_penalty(var/r)

	switch(r)
		if(2 to 10)
			penalty = 1.5*r
		if(11 to 30)
			penalty = (1.3*(r+1))
		if(31 to 999)
			penalty = (1.3*(r+25) - 1.03*r)
		else return 0.5

	penalty = 1 - penalty/100
	return penalty
	*/

/*
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#DEFINE SPECTRUM 26

/datum/logrus/mana
	var/list
		mana[5][SPECTRUM]

	var/origin



/datum/logrus/mana/proc/get_amt(var/p as num, var/c as num) //p - polarisation, c - color ; returns total amount of mana of amount of specified color|polarisation if specified
	var/amt
	if(!p)
		if(!c)
			for(var/i = 0, i < 5, i++)
				for(var/j = 0, j < SPECTRUM, j++)
					amt += mana[i][j]
		else
			for(var/i = 0, i < 5, i++)
				amt += mana[i][c]
	else
		if(!c)
			for(var/j = 0, j < SPECTRUM, j++)
				amt += mana[p][j]
		else
			amt = mana[p][c]
	return amt

/datum/logrus/mana/proc/polarisate(var/n as num)
	for(var/i = 0, i < 5, i++)
		if(i = n)
			continue
		for(var/j = 0, j < SPECTRUM, j++)
			mana[n][j] += mana[i][j]
			mana[i][j] = 0

/datum/logrus/mana/proc/randomize_color(var/n as num)
	var/datum/logrus/mana/dummy = new
	var/total
	for(var/i = 0, i < 5, i++)
		var/total = get_amt(i)
		for(var/j = 0, j < SPECTRUM, j++)
			dummy.mana[i][j] = total/SPECTRUM

	if(get_amt() = dummy.get_amt())
		mana = dummy.mana
		. = 1
	del dummy
	return

/datum/logrus/mana/proc/split(var/n as num)
	if(n, n > 0, n < 5)
		var/datum/logrus/mana/D = new
		for(var/i = 0, i < 5, i++)
			for(var/j = 0, j < SPECTRUM, j++)
				D.mana[i][j] = n*mana[i][j]
				//mana -= D.mana[i][j]
		return D

/datum/logrus/mana/proc/substract(var/datum/logrus/mana/D)
	var/datum/logrus/mana/dummy = new
	dummy.mana = mana
	for(var/i = 0, i < 5, i++)
		for(var/j = 0, j < SPECTRUM, j++)
			if(D.mana[i][j] = 0)
				continue
			else if(dummy.mana[i][j] < D.mana[i][j])
				del dummy
				return 0
			else
				dummy.mana[i][j] -= D.mana[i][j]

	mana = dummy.mana
	del dummy
	return 1

/datum/logrus/mana/proc/add(var/datum/logrus/mana/D)
	for(var/i = 0, i < 5, i++)
		for(var/j = 0, j < SPECTRUM, j++)
			mana[i][j] += D.mana[i][j]

	del D


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/logrus/mana
	var/datum/logrus/mana/M =  //These are mana datums. Later. Or one mana datum. XZ

	proc/Destroy()
		del src

/obj/logrus/mana/radiation/perform()
	var/list/spells = list()
	var/n
	var/r = 125
	var/total = get_amt(M)
	var/loss
	var/portion

	for(var/obj/logrus/spell/S in range(get_amt(M))
		spells += S
		n++
		var/d = get_dist(src, S)
		if(d < r)
			r = d

	loss = split(transfer_penalty(r)*total / n)
	substract(loss)
			//Should add error log here
	total = get_amt(M)
	portion = split(total/n)

	for(var/obj/logrus/spell/S in spells)
		M.substract(portion)
		S.mana.add(portion)

	empulse(loss)

	if(get_amt(M) = 0)
		Destroy()

/obj/logrus/mana/radiation
	var/target_coordinates
	var/target_spec

/obj/logrus/mana/transfer/perform()
	var/list/spells = list()







/obj/logrus/mana/transfer/dest/perform()



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/logrus/proc/angle(var/turf/A, var/turf/B)
	var/ax = x - A.x
	var/ay = y - A.y
	var/bx = x - B.x
	var/by = y - B.y
	var/angle

	var/M = ax * bx + ay * by
	if(!M)
		angle = 90

	var/ab = sqrt((ax+ay) * (bx+by))
	angle = arccos(M/ab)






/obj/logrus/proc/send(var/target, var/amt, var/t = 0)
	if(!target || !mana)
		return

	if(mana < amt)
		amt = mana
		mana = 0
	else
		mana - amt

	var/waste
	waste = amt - amt * transfer_penalty(target)
	amt -= waste
	recipient.recive(amt)

	//transfer_effects(target, waste)

/obj/logrus/proc/recive(amt)
	mana += amt

/obj/logrus/prov/drain(var/target, var/amt, var/t = 0)
	if(!target)
		return

	amt = target.yield(amt)


obj/logrus/proc/Transfer(target, amt, t = 0)
	var/obj/logrus/T

	if(!t)
		t = transfer_penalty(target)

	if(isspell(target)) T = target
	else
		for(var/obj/logrus/spellcraft/l in target)
			T = l

	if(T)
		T.mana += t*amt
		return 1

	return 0

obj/logrus/proc/transfer(target, amt, var/t = 0)
	var/obj/logrus/T
//	T = get_logrus()
	if(!t)
		t = transfer_penalty(target)



obj/effect/proc_holder/logrus/spellcraft/consume(amt, t)
	if(mana < amt)
		amt = mana
		mana = 0
	else
		mana -= amt

	world << "[amt] consumed by [name]"
	return amt

//F = L + M - K
//		manainc = (-((x-35)**2)/(91.7*x+1105)+1.5)
//(-(1000/(x+5))^0.38)-((0.014x)^2)+10


*/

