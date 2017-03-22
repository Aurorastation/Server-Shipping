/*
 * Hooks to set up the shipping system for the round.
 */

/**
 * Does all of the shipping ID init at round start.
 */
/hook/startup/proc/initialize_shipping()
	if (!shippping_return)
		log_debug("SHIPPING: Global shipping return point is not marked.")

	load_shipping_ids()

	return 1

/**
 * Loads up shipping lists for the configuration datum.
 */
/hook/startup/proc/initialize_shipping_servers()
	if (!config)
		// This shouldn't be possible, but sure!
		return 0

	config.loadshippingservers("config/shipping_servers.txt")

	return 1

/**
 * @name	load_shipping_ids
 * @desc	Will load the shipping_ids.txt and save it into the global_shipping_ids list.
 *			Expects the file to be a JSON list consisting of lists with 2 values per list.
 *			Example:
 *			[
 *				["shippingID1", "/path/to/item"]
 *			]
 */
/proc/load_shipping_ids()
	var/file_data = file2text("config/shipping_ids.txt")
	var/list/lines = json_decode(file_data)

	for (var/line in lines)
		var/list/tuple = line
		if (!islist(tuple) || tuple.len != 2)
			log_debug("Invalid data when reading shipping_ids. '[line]'")
			continue

		global_shipping_ids[tuple[1]] = tuple[2]
		global_shipping_paths[tuple[2]] = tuple[1]

/**
 * @name	loadshippingservers
 * @desc	Proc for loading the list of shipping servers from a JSON file.
 * 			Expects the file to contain a JSON list of objects with "ip", "name", and "auth" properties.
 * @param	str filename	The filename from which to load the data.
 *
 * @return	bool			TRUE upon success, FALSE upon failure.
 */
/datum/configuration/proc/loadshippingservers(filename)
	var/list/lines = list()
	try
		lines = json_decode(file2text(filename))
	catch()
		log_debug("SHIPPING: Failure loading shipping server list.")
		return FALSE

	for (var/t in lines)
		if (!islist(t))
			continue

		// Check for malformed data.
		var/list/curr = t
		if (curr.len != 3)
			continue

		try
			authedservers[curr["ip"]] = new /datum/shippingservers(curr["ip"],
				curr["name"], curr["auth"])
			log_debug("SHIPPING: Added server: [jointext(curr, ", ")] to shipping server list.")
		catch(var/e)
			log_debug("SHIPING: Exception caught while adding server to server list: [e]")