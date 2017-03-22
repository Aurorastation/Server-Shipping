/*
 * A few variables for shoving into your configuration datum.
 * Or making into global variables, depending on your preference.
 */
/datum/configuration
	var/shipping_auth = "memes"
	var/list/authedservers = list()

/**
 * The storage datum for shipping servers.
 */
/datum/shippingservers
	var/serverip				// The IP and port of the target server. Format: ip.goes.here:port
	var/servername				// Text name for the server.
	var/serverauth				// The password of the individual destination server.
	var/list/allowedshipids		// A list of allowed shipping IDs for this server.
								// To be set by pinging the server.

/**
 * Constructor
 *
 * @param	str _serverip	The string representing the server's IP and port. Format: ip.goes.here:port
 * @param	str _servername	The string representing the server's name. Has no real bearing.
 * @param	str _serverauth	The password that the destination server is expecting us to send to them.
 */
/datum/shippingservers/New(_serverip, _servername, _serverauth)
	if(!_serverip || !_servername || !_serverauth)
		throw EXCEPTION("Invalid arguments sent to shippingservers/New().")

	serverip = _serverip
	servername = _servername
	serverauth = _serverauth
