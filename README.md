# High End Boosting 🚘🚔

This script adds car boosting jobs. To be able to take these you need an item, a special token (You have to add these to your server circlation yourself but the item is included in the script). The jobs are fairly straight forward: When you got the token, head over to Hector, the guy who gives you the missions. If you have a token you can pick any job, but you need to pay the entry fee. Hector will give you a location of where the car is. Head over there. Some jobs you can sneak and steal without even firing a single bullet, but some might take more brute force. Steal the car and wait for the tracker to turn off. When it's off Hector will give you the GPS location for the dropoff spot. Deliver the car and you will be handed a slip that says Hector owes you some parts. You can take these slips to any  [cw-vehicleswap](https://github.com/Coffeelot/cw-vehicleswap) spot that does special jobs, and if you have the correct car you can get it modified.

Only includes 3 jobs and 3 locations. Up to you to add what you want to add! The slip you get will hold the value of the name of the car you take, so it will work with any type of car you add to this script. All you need to do is add a special swap in [cw-vehicleswap](https://github.com/Coffeelot/cw-vehicleswap) where that model is used, see the special swaps in the bottom of the config for examples.

This is a companion script for [cw-vehicleswap](https://github.com/Coffeelot/cw-vehicleswap).

# Preview 📽
[![YOUTUBE VIDEO](http://img.youtube.com/vi/3BmZ8fIAXpg/0.jpg)](https://youtu.be/3BmZ8fIAXpg)

# Developed by Coffeelot and Wuggie
[More scripts by us](https://github.com/stars/Coffeelot/lists/cw-scripts)  👈\
[Support, updates and script previews](https://discord.gg/FJY4mtjaKr) 👈

# Config 🔧
The script has Jobs and Locations split up, and randomizes locations each time you take the job. 
## locations object
**Guards**: This holds all the guards. Guards are defined with `model`, `weapon` and (optionally if you add `GuardPositions`) `coords`\
**GuardPositions**: Holds Vector4s of potential positions guards can be placed at\
**Civilians**: Same as guards, but passive NPCs\
**CivilianPositions**: Same as GuardPositions, but passive NPCs\
**GuardCars**: Vehicles that will spawn. Each one is defined by `model` and `coords`\
**VehiclePosition**: Postion of the vehicle you are stealing\

## job object
**Model**: Model of the car you are stealing\
**RunCost**: Cost to take the job\
**Timer**: Timer on the tracker (tracker currently isn't working)\ 
**MissionDescription**: Text that shows up when you interact with Hector\
**Messages**: These are Optional, but if you want to personalize the messages per mission you can add it here. First are sent when you take the job. Second are send when you got the car. Third are sent when you turn it in.\
**MinimumPolice**: Minimum police required to take the job\
**Locations**: Which of the locations can this mission use\

Don't forget to add the jobs in the Config.Jobs!

# Add to qb-core ❗
Items to add to qb-core>shared>items.lua 
```
	["swap_slip"] =          {["name"] = "swap_slip",         ["label"] = "Vehicle Swap Slip",                  ["weight"] = 100, ["type"] = "item", ["image"] = "cayo_deliverynote.png", ["unique"] = true, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Document that proves you can get your car swapped"},
	["swap_token"] =          {["name"] = "swap_token",         ["label"] = "A weird gold coin",                  ["weight"] = 100, ["type"] = "item", ["image"] = "token.png", ["unique"] = false, ["useable"] = false, ['shouldClose'] = false, ["combinable"] = nil, ["description"] = "Smells a bit like oil and old farming equipment"},

```
## Making the names show up in to the Inventory 📦
If you want to make the vehicle name show up in QB-Inventory:
Open `app.js` in `qb-inventory`. In the function `FormatItemInfo` you will find several if statements. Head to the bottom of these and add this before the second to last `else` statement (after the `else if` that has `itemData.name == "labkey"`). Then add this between them:
```
else if (itemData.name == "swap_slip") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html("<p>Vehicle: " + itemData.info.vehicle + "</p>");
        }
``` 

Also make sure the images are in qb-inventory>html>images

# Dependencies

* qb-target - https://github.com/BerkieBb/qb-target


## Developed by Coffeelot#1586 and Wuggie#1683
