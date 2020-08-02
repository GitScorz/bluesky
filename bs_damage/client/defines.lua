-- Wound
isBleeding = 0
bleedTickTimer, advanceBleedTimer = 0, 0
fadeOutTimer, blackoutTimer = 0, 0

onPainKiller = 0
wasOnPainKillers = false

onDrugs = 0
wasOnDrugs = false

legCount = 0
armcount = 0
headCount = 0

playerHealth = nil
playerArmour = nil

limbNotifId = 'MHOS_LIMBS'
bleedNotifId = 'MHOS_BLEED'
bleedMoveNotifId = 'MHOS_BLEEDMOVE'