COMPONENTS.Convar = {
    MAX_CLIENTS = { value = GetConvar('sv_maxclients', 32) },
    LOGGING = { value = tonumber(GetConvar('log_level', 0)) },
    RRP_VERSION = { value = GetConvar('rrp_version', "UNKNOWN") },
    VOIP_CHANNEL = { value = GetConvar('voip_channel', "NOT SET") }
}