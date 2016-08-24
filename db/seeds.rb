# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create title: 'Bill and Ted\'s Excellent Adventure',
            description: "Bill (Alex Winter) and Ted (Keanu Reeves) are high "\
              "school buddies starting a band. However, they are about to fail "\
              "their history class, which means Ted would be sent to military "\
              "school. They receive help from Rufus (George Carlin), a "\
              "traveler from a future where their band is the foundation for "\
              "a perfect society. With the use of Rufus' time machine, Bill "\
              "and Ted travel to various points in history, returning with "\
              "important figures to help them complete their final history "\
              "presentation.",
            small_cover_url: 'http://ia.media-imdb.com/images/M/MV5BMTk3Mjk5MzI3OF5BMl5BanBnXkFtZTcwMTY4MzcyNA@@._V1_UY1200_CR85,0,630,1200_AL_.jpg',
            large_cover_url: 'http://placehold.it/665x375'

Video.create title: 'Mulholland Drive',
            description: "A dark-haired woman (Laura Elena Harring) is left "\
              "amnesiac after a car crash. She wanders the streets of Los "\
              "Angeles in a daze before taking refuge in an apartment. There "\
              "she is discovered by Betty (Naomi Watts), a wholesome "\
              "Midwestern blonde who has come to the City of Angels seeking "\
              "fame as an actress. Together, the two attempt to solve the "\
              "mystery of Rita's true identity. The story is set in a "\
              "dream-like Los Angeles, spoilt neither by traffic jams nor smog.",
            small_cover_url: 'http://placehold.it/166x236',
            large_cover_url: 'http://placehold.it/665x375'

Video.create title: 'Mad Max: Fury Road',
            description: "Years after the collapse of civilization, the "\
              "tyrannical Immortan Joe enslaves apocalypse survivors inside "\
              "the desert fortress the Citadel. When the warrior Imperator "\
              "Furiosa (Charlize Theron) leads the despot's five wives in a "\
              "daring escape, she forges an alliance with Max Rockatansky "\
              "(Tom Hardy), a loner and former captive. Fortified in the "\
              "massive, armored truck the War Rig, they try to outrun the "\
              "ruthless warlord and his henchmen in a deadly high-speed chase "\
              "through the Wasteland.",
            small_cover_url: 'http://placehold.it/166x236',
            large_cover_url: 'http://placehold.it/665x375'
