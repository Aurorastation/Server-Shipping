/**
 * Helper proc for actions before an object is assigned to the garbage collector.
 */
/datum/proc/Destroy()
	return

/**
 * Helper proc for ensuring that Exited and Entered chains are not broken
 * when assinging a new loc destination.
 */
/atom/movable/proc/forceMove(var/atom/destination)
	if(destination)
		if(loc)
			loc.Exited(src)
		loc = destination
		loc.Entered(src)
		return 1
	return 0