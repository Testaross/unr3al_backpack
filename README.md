# unr3al_backpack

This resource was created as a free script for backpacks using ox_inventory

<b>Features:</b>
- 0.0 ms Usage
- Customizable item name and storage parameters
- Compatibility for ESX

## Installation

- Download this script
- Add backpack to inventory as it is in "Extra Information" below
- Add backpack image to inventory images (found in `unr3al_backpack/_inventory_images/backpack.png`)
- Put script in your `resources` directory
- ensure `unr3al_backpack` *after* `ox_lib` but *before* `ox_inventory`

# Dependencies
 - ox_inventory

## Extra Information

You can add infinite backpacks, just adjust the config for your liking.
Then add the export to your `ox_inventory/data/items.lua`. The ending of the export is always the itemname you defined in your config.lua



Item to add to `ox_inventory/data/items.lua`
```
	['bag1'] = {
		label = 'Backpack',
		weight = 220,
		stack = false,
		consume = 0,
		client = {
			export = 'unr3al_backpack.openBackpack_bag1'
		}
	},
		['bag2'] = {
		label = 'Backpack',
		weight = 220,
		stack = false,
		consume = 0,
		client = {
			export = 'unr3al_backpack.openBackpack_bag2'
		}
	},
```
Configure the bags in `unr3al_backpack/config.lua`
```
    ['bag1'] = {
        Slots = 35,
        Weight = 20000,
        Label = 'Backpack',
        Uniform = {
            Male = {
                ['bags_1'] = 41,
                ['bags_2'] = 0,
            },
            Female = {
                ['bags_1'] = 41,
                ['bags_2'] = 0,
            }
        },
    },
    ['bag2'] = {
        Slots = 15,
        Weight = 5000,
        Label = 'Backpack',
        Uniform = {
            Male = {
                ['bags_1'] = 41,
                ['bags_2'] = 0,
            },
            Female = {
                ['bags_1'] = 41,
                ['bags_2'] = 0,
            }
        },
    },
```

## Preview from Wasabi
- The preview is going to get updated at some point for the clothing part of this fork
https://www.youtube.com/watch?v=OsjuUtE9Pg8

# Support
https://discord.gg/euewAxCAUN
