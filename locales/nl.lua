local Translations = {

    notify = {
        ['cancel'] = "Geannuleerd",
        ['active_cooldown'] = "Cooldown Active...",
        ['press_to_dump'] = "[E] - Scrap Menu",
        ['drop_vehicle'] = "[E] - Om het voertuig te dumpen",
        ['job_done_good_work'] = "Goed gedaan, alles verliep volgens plan!",
        ['wreck_is_bumped'] = "Het wrak is gedumpt, rijd terug naar de aangegeven punt op de kaart.",
        ['go_to_work_vehicle'] = "Ga naar de gele vrachtwagen op je kaart!",
        ['go_to_dump_location'] = "Rijd dit wrak naar het aangegeven punt op de kaart",
        ['job_failed'] = "De job is mislukt, hoe kun je het toch verpesten!",
        ['not_enough_items'] = "Je hebt niet genoeg items of de juiste items bij je",
        ['own_the_vehicle'] = "Gefeliciteerd deze gestolen voertuig is omgetikt, en is nu van jou!",
        ['can_not_steel_player_vehicle'] = "Je kunt geen andere spelers hun auto stelen!",
        ['not_enough_money_to_rent'] = "Je hebt niet genoeg geld om ook maar iets te huren!",
        ['vehicle_is_blacklisted'] = "Je kunt dit voertuig niet gebruiken..",
        ['drive_backwards'] = "Rijd achteruit naar de aangegeven locatie",
    },
    menu = {
        ['menu_close'] = "Sluit",
        ['menu_header'] = "NPC Voertuig Menu",
        ['menu_option_1'] = "Steel Vehicle",
        ['menu_option_1_dec'] = "Steel",
        ['menu_option_2'] = "Onderdelen",
        ['menu_option_2_dec'] = "Vernietig het voertuig voor onderdelen",
        ['menu_option_3'] = "Materialen",
        ['menu_option_3_dec'] = "Vernietig het voertuig voor materialen",
    },
    progressbar = {
        ['info1'] = "Frame nummer verwijderen....",
        ['info2'] = "Frame schoonmaken....",
        ['info3'] = "Frame number veranderen....",
        ['demolish'] = "Voertuig slopen",
    },
}

Lang = Locale:new({
    phrases = Translations, 
    warnOnMissing = true
})
