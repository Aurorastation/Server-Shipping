/*
 * Baystation12 standard proc for logging debug messages into the log file.
 */
/proc/log_debug(var/message)
	world << "DEBUG: [message]"

/*
 * Baystation12 standard proc for garbage collection.
 */
/proc/qdel(var/datum/A)
	if (!A)
		return

	if (istype(A))
		A.Destroy()

	del(A)

/*
 * Baystation12 helper proc for identifying lists.
 */
/proc/islist(var/A)
	return istype(A, /list)

/*
 * Helper proc for removing null entries from lists.
 */
/proc/listclearnulls(list/list)
	if(istype(list))
		while(null in list)
			list -= null
	return