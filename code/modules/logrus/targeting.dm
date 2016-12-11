//here go helpers for targeting

//
/proc/GetOffset(var/atom/A, var/atom/B, var/ax = "x")
	var/turf/Aloc = GetTurfLoc(A)
	var/turf/Bloc = GetTurfLoc(B)

	if(Aloc.z != Bloc.z)
		return null


	if(ax == "x")
		return Aloc.x - Bloc.x
	if(ax == "y")
		return Aloc.y - Bloc.y


/proc/GetTargetTurf(var/atom/initial, var/xt, var/yt)
	xt = initial.x - xt
	yt = initial.y - yt

	var/turf/T = locate(xt,yt,initial.z)
	return T