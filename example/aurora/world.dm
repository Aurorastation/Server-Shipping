
world/Topic()
	var/list/response[] = list()
	var/list/queryparams[] = json_decode(T)
	queryparams["addr"] = addr //Add the IP to the queryparams that are passed to the api functions
	var/query = queryparams["query"]
	var/auth = queryparams["auth"]
	log_debug("API: Request Received - from:[addr], master:[master], key:[key]")
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key], auth:[auth] [log_end]"

	if (!ticker) //If the game is not started most API Requests would not work because of the throtteling
		response["statuscode"] = 500
		response["response"] = "Game not started yet!"
		return json_encode(response)

	if (isnull(query))
		log_debug("API - Bad Request - No query specified")
		response["statuscode"] = 400
		response["response"] = "Bad Request - No query specified"
		return json_encode(response)

	var/datum/topic_command/command = topic_commands[query]

	//Check if that command exists
	if (isnull(command))
		log_debug("API: Unknown command called: [query]")
		response["statuscode"] = 501
		response["response"] = "Not Implemented"
		return json_encode(response)

	if(command.check_params_missing(queryparams))
		log_debug("API: Mising Params - Status: [command.statuscode] - Response: [command.response]")
		response["statuscode"] = command.statuscode
		response["response"] = command.response
		response["data"] = command.data
		return json_encode(response)
	else
		command.run_command(queryparams)
		log_debug("API: Command called: [query] - Status: [command.statuscode] - Response: [command.response]")
		response["statuscode"] = command.statuscode
		response["response"] = command.response
		response["data"] = command.data
		return json_encode(response)