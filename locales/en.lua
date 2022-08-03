local Translations = {
    error = {
        ["canceled"]                    = "Canceled",
        ["someone_recently_did_this"]   = "Someone recently did this, try again later..",
        ["cannot_do_this_right_now"]    = "Cannot do this right now...",
        ["you_failed"]                  = "You failed!",
        ["you_cannot_do_this"]          = "You cannot do this..",
        ["you_dont_have_enough_money"]  = "You Dont Have Enough Money",
    },
    success = {
        ["case_has_been_unlocked"]              = "Security case has been unlocked",
        ["you_removed_first_security_case"]     = "You removed the the first layer of security on the case",
        ["you_got_paid"]                        = "You got paid",
        ["send_email_right_now"]                 = "I will send you an e-mail right now!",
        ["case_beep"]                           = "There is something beeping??",
    },
    info = {
        ["talking_to_boss"]             = "Talking to Hector..",
        ["unlocking_case"]              = "Unlocking case..",
        ["checking_quality"]            = "Checking Quality",
        ["dropoff"]                     = "Drop off car",
        ["paperslip"]                   = "There was a paper slip layin next to where you left the car."
    },
    mailstart = {
        ["sender"]                      = "Unknown",
        ["subject"]                     = "Vehicle Location",
        ["message"]                     = "Updated your gps with the location to a vehicle I got a tip about that contains a briefcase. Retrieve whats inside it and bring it back to me. I've given you a special key that would be used to remove the first layer of security on the case.",
    },
    mail = {
        ["sender"]                      = "Unknown",
        ["subject"]                     = "Goods Collection",
        ["message"]                     = "Looks like you got the goods, the case should unlock automatically 5 minutes after you unlocked the first layer of security on it. Once completed bring back the items to me and get paid.",
    },
    mailEnd = {
        ["sender"]                      = "Unknown",
        ["subject"]                     = "Goods Delivered",
        ["message"]                     = "Good job. Take the slip to someone who knows what to do",
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
