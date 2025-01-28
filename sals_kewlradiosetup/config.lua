-- config.lua

Config = {}

-- List of CodePlug options
Config.CodePlugs = {
    { label = "Public Safety", value = "pubsafety",  allowedJobs = { "police", "sasp", "lspd", "usms", "safr" }},
    --{ label = "Backup 1", value = "codeplug" },
    -- Add more CodePlug options as needed
}

-- Command to open the radio menu
Config.MenuCommand = "myradio" -- Change this to your desired command

-- List of allowed jobs to access the menu
Config.AllowedJobs = {
    "police",
    "safr",
    "sasp",
    "usms",
}