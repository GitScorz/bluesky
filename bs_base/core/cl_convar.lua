COMPONENTS.Convar = {
    MAX_CLIENTS = { value = GetConvarInt('sv_maxclients', 32) },
    LOGGING = { value = GetConvarInt('log_level', 0) },
    RRP_VERSION = { value = GetConvar('rrp_version', "UNKNOWN") },
    VOIP_CHANNEL = { value = GetConvar('voip_channel', "NOT SET") }
}