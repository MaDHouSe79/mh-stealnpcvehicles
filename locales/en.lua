local Translations = {

    notify = {
        ['cancel'] = "Canceled...",
        ['active_cooldown'] = "Cooldown Active...",
        ['press_for_menu'] = "[E] - Scrap Menu",
        ['drop_vehicle'] = "[E] - To bump the vehicle",
        ['job_done_good_work'] = "Good job, everything went according to plan!",
        ['wreck_is_bumped'] = "The wreck is bumped, drive back to the ",
        ['go_to_work_vehicle'] = "Go to the yellow truck on your map!",
        ['go_to_dump_location'] = "Drive this wreck to the designated point on the map",
        ['job_failed'] = "The job has failed, how could you screw it up!",
        ['not_enough_items'] = "You don't have enough items or the right items with you",
        ['own_the_vehicle'] = "Congratulations this stolen vehicle has been tipped over and is now yours!",
        ['can_not_steel_player_vehicle'] = "You can't steal other player vehicles!",
        ['not_enough_money_to_rent'] = "You don't have enough money to rent a thing!",
        ['vehicle_is_blacklisted'] = "You can't use this vehicle..",
        ['drive_backwards'] = "Drive backwards to the indicated location.",
    },
    menu = {
        ['menu_close'] = "Close",
        ['menu_header'] = "NPC Vehicle Menu",
        ['menu_option_1'] = "Steal Vehicle",
        ['menu_option_1_dec'] = "Steal",
        ['menu_option_2'] = "Parts",
        ['menu_option_1_dec'] = "Destroy vehicle for parts",
        ['menu_option_3'] = "Materials",
        ['menu_option_3_dec'] = "Destroy vehicle for materials",
    },
    progressbar = {
        ['info1'] = "Removing frame number....",
        ['info2'] = "Cleaning frame....",
        ['info3'] = "Tap new frame number....",
        ['demolish'] = "Demolish Vehicle",
    },
}

Lang = Locale:new({
    phrases = Translations, 
    warnOnMissing = true
})
