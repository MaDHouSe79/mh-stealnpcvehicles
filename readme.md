# mh-stealnpcvehicles
- steal any npc vehicles


# Add in `qb-core/shared/items.lua`
```lua
    -- mh-stealnpcvehicles items
    ["axleparts"]                   = {["name"] = "axleparts",			        ["label"] = "axleparts",	    	    ["weight"] = 0, ["type"] = "item",  ["image"] = "axleparts.png",     ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "axleparts"},
    ["brakes1"]                     = {["name"] = "brakes1",			        ["label"] = "brakes1",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "brakes1.png",       ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "brakes1"},
    ["bumper"]                      = {["name"] = "bumper",			            ["label"] = "bumper",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "bumper.png",        ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "bumper"},
    ["carbattery"]                  = {["name"] = "carbattery",			        ["label"] = "carbattery",	    	    ["weight"] = 0, ["type"] = "item",  ["image"] = "carbattery.png",    ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "carbattery"},
    ["door"]                        = {["name"] = "door",			            ["label"] = "door",	    	            ["weight"] = 0, ["type"] = "item",  ["image"] = "door.png",          ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car door"},
    ["engine1"]                     = {["name"] = "engine1",			        ["label"] = "engine1",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "engine1.png",       ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car engine1"},
    ["exhaust"]                     = {["name"] = "exhaust",			        ["label"] = "exhaust",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "exhaust.png",       ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car exhaust"},
    ["headlights"]                  = {["name"] = "headlights",			        ["label"] = "headlights",	    	    ["weight"] = 0, ["type"] = "item",  ["image"] = "headlights.png",    ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car headlights"},
    ["hood"]                        = {["name"] = "hood",			            ["label"] = "hood",	    	            ["weight"] = 0, ["type"] = "item",  ["image"] = "hood.png",          ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car hood"},
    ["roof"]                        = {["name"] = "roof",			            ["label"] = "roof",	    	            ["weight"] = 0, ["type"] = "item",  ["image"] = "roof.png",          ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car roof"},
    ["seat"]                        = {["name"] = "seat",			            ["label"] = "seat",	    	            ["weight"] = 0, ["type"] = "item",  ["image"] = "seat.png",          ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car seat"},
    ["skirts"]                      = {["name"] = "skirts",			            ["label"] = "skirts",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "skirts.png",        ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car skirts"},
    ["sparkplugs"]                  = {["name"] = "sparkplugs",			        ["label"] = "sparkplugs",	    	    ["weight"] = 0, ["type"] = "item",  ["image"] = "sparkplugs.png",    ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car sparkplugs"},
    ["spoiler"]                     = {["name"] = "spoiler",			        ["label"] = "spoiler",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "spoiler.png",       ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car spoiler"},
    ["stockrim"]                    = {["name"] = "stockrim",			        ["label"] = "stockrim",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "stockrim.png",      ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car stockrim"},
    ["suspension1"]                 = {["name"] = "suspension1",			    ["label"] = "suspension1",	    	    ["weight"] = 0, ["type"] = "item",  ["image"] = "suspension1.png",   ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car suspension1"},
    ["tire"]                        = {["name"] = "tire",			            ["label"] = "tire",	    	            ["weight"] = 0, ["type"] = "item",  ["image"] = "tire.png",          ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car tire"},
    ["transmission1"]               = {["name"] = "transmission1",			    ["label"] = "transmission1",	    	["weight"] = 0, ["type"] = "item",  ["image"] = "transmission1.png", ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car transmission1"},
    ["trunk"]                       = {["name"] = "trunk",			            ["label"] = "trunk",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "trunk.png",         ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car trunk"},
    ["turbo"]                       = {["name"] = "turbo",			            ["label"] = "turbo",	    	        ["weight"] = 0, ["type"] = "item",  ["image"] = "turbo.png",         ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = "car turbo"},
    ['oxycutter']                   = {['name'] = 'oxycutter',          		['label'] = 'Zuurstofsnijder',      	['weight'] = 1500,		['type'] = 'item', 		['image'] = 'oxycutter.png', 	          		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'Oxygen cutter, for cutting hard steel'},
    ['oxygen-tank']                 = {['name'] = 'oxygen-tank', 				['label'] = 'Oxygen Tank', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'oxygen-tank.png', 	        		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'Oxygen Tank'},
    ['electric_scrap']              = {['name'] = 'electric_scrap', 			['label'] = 'Electric Scrap', 			['weight'] = 0, 		['type'] = 'item', 		['image'] = 'electric_scrap.png',         		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'Electric Scrap'},
    ['ducttape']                    = {['name'] = 'ducttape', 					['label'] = 'ducttape', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'ducttape.png', 		        	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'ducttape'},
```
# NOTE for the hardware shop
Dont forget to add the two items in your hardware shop.
```lua

[16] = {
    name = "oxycutter",
    price = 5000,
    amount = 15,
    info = {},
    type = "item",
    slot = 16,
},
[17] = {
    name = "oxygen-tank",
    price = 1000,
    amount = 15,
    info = {},
    type = "item",
    slot = 17,
},
```


## 🙈 Youtube & Discord
- [Youtube](https://www.youtube.com/c/MaDHouSe79)
- [Discord](https://discord.gg/cEMSeE9dgS)

# LICENSE
[GPL LICENSE](./LICENSE)<br />
&copy; [MaDHouSe79](https://www.youtube.com/@MaDHouSe79)
