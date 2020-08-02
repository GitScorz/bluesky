Config = {}

Config.SwingTimeout = 7 * 1000 -- seconds to stop the locking process if the door isn't close to it's CLOSED position
Config.MaxAuthed = 5

Config.Lockpick = {
    animDuration = 5, -- in seconds
    chance = 25, -- chance of successful lockpick 0-100%
}

Config.EmergencyJobs = { 'police', 'doctor', 'ems', 'judge' }