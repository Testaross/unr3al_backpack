-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------
Config = {}

Config.checkForUpdates = true -- Check for updates?

Config.OneBagInInventory = true -- Allow only one bag in inventory?

Config.BackpackStorage = {
    slots = 35, -- Slots of backpack storage
    weight = 20000 -- Total weight for backpack
}


Config.Uniforms = {

    Male = {
        ['bags_1'] = 41,
        ['bags_2'] = 0,
    },
    Female = {
        ['bags_1'] = 41,
        ['bags_2'] = 0,
    }
}

Config.CleanUniforms = {

    Male = {
        ['bags_1'] = 0,
        ['bags_2'] = 0,
    },
    Female = {
        ['bags_1'] = 0,
        ['bags_2'] = 0,
    }
}

Strings = { -- Notification strings
    action_incomplete = 'Action Incomplete',
    one_backpack_only = 'You can only have 1x backpack!',
    backpack_in_backpack = 'You can\'t place a backpack within another!',

}
