-------------------
-- CONFIG --
-------------------
Config = {}

Config.command = "help" -- the command that will be typed
Config.MedicArriving = "Medic is arriving" -- the message that will appear with the medic is arriving
Config.Doctor = 0 -- Minimum Amount of EMS to work
Config.Doctormessage = "There is too many medics online", "error" -- the message that will show if there are medics online
Config.NEM = "Not Enough Money" -- the message that will show if the player does not have Enough Money
Config.Price = 2000 -- the price of the service done
Config.ReviveTime = 20000  --in msec
Config.disableMovement = true -- toggles player movment when the aid message is on screen
Config.disableCarMovement = true -- toggles car movment when the aid message is on screen
Config.disableMouse = false  -- toggles users mouse when the aid message is on screen
Config.disableCombat = true -- toggles combat when the aid message is on screen
Config.doctormodal = "s_m_m_doctor_01" -- the ped that will be in the car picked bellow
Config.carmodal = "ambulance" -- the modal of the car the npc will drive 
Config.plate = "Doctor" -- the name on the cars licenceplate
Config.Siren = true -- enable the Sirens if any
Config.ND = "This can only be used when dead" -- message that will show if the player is not dead
Config.doctaid = "The doctor is giving you medical aid" -- the message that will show with the doctor is reviveing you
Config.TreatmentDone = "Your treatment is done, you were charged: " -- the message that shows up when treatment is done (note: the price will be at the end (ex: Your treatment is done, you were charged: 2000))
Config.JobName = 'ambulance' -- the job to cheack for, depends on the Minimum Amount of EMS to work and vica-versa
Config.MoneyAccount = 'bank' -- the moneyaccount with want the price to be removed from