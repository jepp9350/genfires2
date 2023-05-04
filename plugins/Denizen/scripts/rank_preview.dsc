cbuy_command:
    type: command
    name: cbuy
    description: See our custom buy screen
    usage: /cbuy <&lt>category<&gt>
    script:
    - inventory open d:custom_buy_interface_main
# The first GUI, where you can choose what category.
custom_buy_interface_main:
    type: inventory
    inventory: chest
    title: Store -<&gt> Choose category
    gui: true
    definitions:
      ranks category: <item[custom_buy_interface_main_item_category_ranks]>
      keys category: <item[custom_buy_interface_main_item_category_keys]>
      close button: <item[custom_buy_interface_main_item_control_close]>
      info: <item[custom_buy_interface_main_item_control_info]>
    size: 36
    procedural items:
    - define result <list>
    # Add some logic!
    - repeat 33:
        - define result:->:<item[gray_stained_glass_pane]>
    - determine <[result]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [ranks category] [] [keys category] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [info] [] [] [] [close button] [] [] [] []
# The info item displayed.
custom_buy_interface_main_item_control_info:
    type: item
    material: player_head
    display name: <&6>Why do I have to pay <&l>real<&r><&6> money!?
    lore:
    - <&7>Short answer: The server needs to be able to run.
    - <&7>Read more about this using <&6>/p2w <&7>and <&6>/expenses<&7>.
    - ""
    - <&6><&n>Click to read our /p2w.
    mechanisms:
        skull_skin: 04049c90-d3e9-4621-9caf-0000aaa24498|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDAxYWZlOTczYzU0ODJmZGM3MWU2YWExMDY5ODgzM2M3OWM0MzdmMjEzMDhlYTlhMWEwOTU3NDZlYzI3NGEwZiJ9fX0=
# The ranks category item displayed.
custom_buy_interface_main_item_category_ranks:
    type: item
    material: name_tag
    display name: <&6><&l>Ranks
    lore:
    - <&7>A list of our dontations ranks.
    - <&8>All dontation ranks are permanent.
# The keys category item displayed.
custom_buy_interface_main_item_category_keys:
    type: item
    material: tripwire_hook
    display name: <&6><&l>Keys
    lore:
    - <&7>A list of our paid keys.
# The close button on the first GUI.
custom_buy_interface_main_item_control_close:
    type: item
    material: barrier
    display name: <&c><&l>Close
    lore:
    - <&7>Close the /buy menu.
# The world script, that detects whenever a category is clicked in the first GUI.
custom_buy_interface_main_world_script:
    type: world
    events:
        # The event when a player clicks the ranks category in the first GUI.
        on player clicks custom_buy_interface_main_item_category_ranks in custom_buy_interface_main:
        - inventory open d:custom_buy_interface_ranks
        # The event when a player clicks the keys category in the first GUI.
        on player clicks custom_buy_interface_main_item_category_keys in custom_buy_interface_main:
        - inventory open d:custom_buy_interface_keys
        # The event when a player clicks the close control button in the first GUI.
        on player clicks custom_buy_interface_main_item_control_close in custom_buy_interface_main:
        - inventory close
        # The event when a player clicks the INFO control button in the first GUI.
        on player clicks custom_buy_interface_main_item_control_info in custom_buy_interface_main:
        - inventory close
        - execute as_player "p2w"
#
# Ranks category menu.
#
custom_buy_interface_ranks:
    type: inventory
    inventory: chest
    title: Store -<&gt> Ranks
    gui: true
    definitions:
      coal rank: <item[custom_buy_interface_ranks_item_rank_coal]>
      iron rank: <item[custom_buy_interface_ranks_item_rank_iron]>
      gold rank: <item[custom_buy_interface_ranks_item_rank_gold]>
      diamond rank: <item[custom_buy_interface_ranks_item_rank_diamond]>
      emerald rank: <item[custom_buy_interface_ranks_item_rank_emerald]>
      token rank: <item[custom_buy_interface_ranks_item_rank_token]>
      ultimate rank: <item[custom_buy_interface_ranks_item_rank_ultimate]>
      back button: <item[custom_buy_interface_ranks_item_control_back]>
    size: 36
    procedural items:
    - define result <list>
    # Add some logic!
    - repeat 28:
        - define result:->:<item[gray_stained_glass_pane]>
    - determine <[result]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [coal rank] [iron rank] [gold rank] [diamond rank] [emerald rank] [token rank] [ultimate rank] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [back button] [] [] [] []
# The Coal rank item displayed in the ranks category.
custom_buy_interface_ranks_item_rank_coal:
    type: item
    material: coal
    display name: <&f>Coal Rank <&8>(<&a>$3 <&8>- <&7>Onetime<&8>)
    lore:
    - <&7>Features<&co>
    - <&6>» Coal kit <&8>(every 24h)
    - <&6>» Sell multiplier <&8>(+0.5)
    - <&6>» 3 Playervaults  <&8>(access to /pv 1-3)
    - <&6>» Colored signs <&8>(Use colors)
    - <&6>» Particles <&8>(access to all particles in /pp)
    - <&6>» 5 Extra generators <&8>(regular)
    - <&6>» 1 Extra generator <&8>(token)
    - <&6>» 4 items in /ah <&8>(sell 4 items in /ah)
    - <&6>» White chat color <&8>(Stand out in chat)
    - <&6>» Your plot wont reset when you prestige
    - ""
    - <&a>Left click to purchase <&8>| Right click to preview kit
# The Iron rank item displayed in the ranks category.
custom_buy_interface_ranks_item_rank_iron:
    type: item
    material: iron_ingot
    display name: <&f>Iron Rank <&8>(<&a>$7 <&8>- <&7>Onetime<&8>)
    lore:
    - <&7>Features<&co>
    - <&6>» Iron kit <&8>(every 24h)
    - <&6>» Sell multiplier <&8>(+0.8)
    - <&6>» 5 Playervaults  <&8>(access to /pv 1-5)
    - <&6>» Colors & magic on signs <&8>(Use magic & colors)
    - <&6>» Particles <&8>(access to all particles in /pp)
    - <&6>» 10 Extra generators <&8>(regular)
    - <&6>» 2 Extra generators <&8>(token)
    - <&6>» 5 items in /ah <&8>(sell 5 items in /ah)
    - <&6>» Chat colors <&8>(Stand out in chat)
    - <&6>» Your plot wont reset when you prestige
    - <&6>» Access to /fly without buying it in /shop
    - ""
    - <&a>Left click to purchase <&8>| Right click to preview kit
# The Gold rank item displayed in the ranks category.
custom_buy_interface_ranks_item_rank_gold:
    type: item
    material: gold_ingot
    display name: <&f>Gold Rank <&8>(<&a>$12 <&8>- <&7>Onetime<&8>)
    lore:
    - <&7>Features<&co>
    - <&6>» Gold kit <&8>(every 24h)
    - <&6>» Sell multiplier <&8>(+1.0)
    - <&6>» 10 Playervaults  <&8>(access to /pv 1-10)
    - <&6>» Colors & magic on signs <&8>(Use magic & colors)
    - <&6>» Particles <&8>(access to all particles in /pp)
    - <&6>» 15 Extra generators <&8>(regular)
    - <&6>» 5 Extra generators <&8>(token)
    - <&6>» 6 items in /ah <&8>(sell 6 items in /ah)
    - <&6>» Chat colors & magic <&8>(Stand out in chat)
    - <&6>» Your plot wont reset when you prestige
    - <&6>» Access to /fly & /tokenshop without buying it in /shop
    - ""
    - <&a>Left click to purchase <&8>| Right click to preview kit
# The Diamond rank item displayed in the ranks category.
custom_buy_interface_ranks_item_rank_diamond:
    type: item
    material: diamond
    display name: <&f>Diamond Rank <&8>(<&a>$17 <&8>- <&7>Onetime<&8>)
    lore:
    - <&7>Features<&co>
    - <&6>» Diamond kit <&8>(every 24h)
    - <&6>» Sell multiplier <&8>(+1.2)
    - <&6>» 15 Playervaults  <&8>(access to /pv 1-15)
    - <&6>» Colors & magic on signs <&8>(Use magic & colors)
    - <&6>» Particles <&8>(access to all particles in /pp)
    - <&6>» 20 Extra generators <&8>(regular)
    - <&6>» 8 Extra generators <&8>(token)
    - <&6>» 7 items in /ah <&8>(sell 6 items in /ah)
    - <&6>» Chat colors & magic <&8>(Stand out in chat)
    - <&6>» Your plot wont reset when you prestige
    - <&6>» Access to /fly & /tokenshop without buying it in /shop
    - <&6>» Access to /nickname <&8>(Change your name in chat)
    - <&6>» Access to claim 3 plots <&8>(+2 plots)
    - ""
    - <&a>Left click to purchase <&8>| Right click to preview kit
# The Emerald rank item displayed in the ranks category.
custom_buy_interface_ranks_item_rank_emerald:
    type: item
    material: emerald
    display name: <&f>Emerald Rank <&8>(<&a>$22 <&8>- <&7>Onetime<&8>)
    lore:
    - <&7>Features<&co>
    - <&6>» Emerald kit <&8>(every 24h)
    - <&6>» Sell multiplier <&8>(+1.5)
    - <&6>» 20 Playervaults  <&8>(access to /pv 1-20)
    - <&6>» Colors & magic on signs <&8>(Use magic & colors)
    - <&6>» Particles <&8>(access to all particles in /pp)
    - <&6>» 25 Extra generators <&8>(regular)
    - <&6>» 12 Extra generators <&8>(token)
    - <&6>» 8 items in /ah <&8>(sell 6 items in /ah)
    - <&6>» Chat colors & magic <&8>(Stand out in chat)
    - <&6>» Your plot wont reset when you prestige
    - <&6>» Access to /fly & /tokenshop without buying it in /shop
    - <&6>» Access to /nickname w. colors <&8>(Change your name in chat)
    - <&6>» Access to claim 4 plots <&8>(+3 plots)
    - ""
    - <&a>Left click to purchase <&8>| Right click to preview kit
# The Token rank item displayed in the ranks category.
custom_buy_interface_ranks_item_rank_token:
    type: item
    material: beacon
    display name: <&f>Token Rank <&8>(<&a>$25 <&8>- <&7>Onetime<&8>)
    lore:
    - <&7>Features<&co>
    - <&6>» Token kit <&8>(every 24h)
    - <&6>» Sell multiplier <&8>(+1.6)
    - <&6>» 30 Playervaults  <&8>(access to /pv 1-30)
    - <&6>» Colors & magic on signs <&8>(Use magic & colors)
    - <&6>» Particles <&8>(access to all particles in /pp)
    - <&6>» 30 Extra generators <&8>(regular)
    - <&6>» 15 Extra generators <&8>(token)
    - <&6>» 9 items in /ah <&8>(sell 6 items in /ah)
    - <&6>» Chat colors & magic <&8>(Stand out in chat)
    - <&6>» Your plot wont reset when you prestige
    - <&6>» Access to /fly & /tokenshop without buying it in /shop
    - <&6>» Access to /nickname w. colors <&8>(Change your name in chat)
    - <&6>» Access to claim 6 plots <&8>(+5 plots)
    - <&6>» Access to /tp <&8>(teleport to other players)
    - ""
    - <&a>Left click to purchase <&8>| Right click to preview kit
# The Ultimate rank item displayed in the ranks category.
custom_buy_interface_ranks_item_rank_ultimate:
    type: item
    material: wither_rose
    display name: <&f>Ultimate Rank <&8>(<&a>$30 <&8>- <&7>Onetime<&8>)
    lore:
    - <&7>Features<&co>
    - <&6>» Ultimate kit <&8>(every 24h)
    - <&6>» Sell multiplier <&8>(+1.8)
    - <&6>» 40 Playervaults  <&8>(access to /pv 1-40)
    - <&6>» Colors & magic on signs <&8>(Use magic & colors)
    - <&6>» Particles <&8>(access to all particles in /pp)
    - <&6>» 35 Extra generators <&8>(regular)
    - <&6>» 20 Extra generators <&8>(token)
    - <&6>» 2 Extra generators <&8>(XP)
    - <&6>» 9 items in /ah <&8>(sell 6 items in /ah)
    - <&6>» Chat colors & magic <&8>(Stand out in chat)
    - <&6>» Your plot wont reset when you prestige
    - <&6>» Access to /fly & /tokenshop without buying it in /shop
    - <&6>» Access to /nickname w. colors <&8>(Change your name in chat)
    - <&6>» Access to claim 10 plots <&8>(+9 plots)
    - <&6>» Access to /tp <&8>(teleport to other players)
    - <&6>» Access to /ride <&8>(Ride other players)
    - ""
    - <&a>Left click to purchase <&8>| Right click to preview kit
# The back button displayed in the ranks category.
custom_buy_interface_ranks_item_control_back:
    type: item
    material: barrier
    display name: <&c><&l>Go back
    lore:
    - <&7>Choose another category.
# A world script, that detects when a player clicks a rank in the ranks category.
custom_buy_interface_ranks_world_script:
    type: world
    events:
        # On player clicks on the back control button.
        on player clicks custom_buy_interface_ranks_item_control_back in custom_buy_interface_ranks:
        - inventory open d:custom_buy_interface_main
        # Coal rank (Left click - Buy)
        on player left clicks custom_buy_interface_ranks_item_rank_coal in custom_buy_interface_ranks:
        - narrate "<proc[custom_buy_interface_ranks_narrate_link].context[coal]>"
        # Coal rank (Right click - Preview kit)
        on player right clicks custom_buy_interface_ranks_item_rank_coal in custom_buy_interface_ranks:
        - execute as_server "kitpreview Coal <player.name>"
        # Iron rank (Left click - Buy)
        on player left clicks custom_buy_interface_ranks_item_rank_iron in custom_buy_interface_ranks:
        - narrate "<proc[custom_buy_interface_ranks_narrate_link].context[iron]>"
        # Iron rank (Right click - Preview kit)
        on player right clicks custom_buy_interface_ranks_item_rank_iron in custom_buy_interface_ranks:
        - execute as_server "kitpreview Iron <player.name>"
        # Gold rank (Left click - Buy)
        on player left clicks custom_buy_interface_ranks_item_rank_gold in custom_buy_interface_ranks:
        - narrate "<proc[custom_buy_interface_ranks_narrate_link].context[gold]>"
        # Gold rank (Right click - Preview kit)
        on player right clicks custom_buy_interface_ranks_item_rank_gold in custom_buy_interface_ranks:
        - execute as_server "kitpreview Gold <player.name>"
        # Diamond rank (Left click - Buy)
        on player left clicks custom_buy_interface_ranks_item_rank_diamond in custom_buy_interface_ranks:
        - narrate "<proc[custom_buy_interface_ranks_narrate_link].context[diamond]>"
        # Diamond rank (Right click - Preview kit)
        on player right clicks custom_buy_interface_ranks_item_rank_diamond in custom_buy_interface_ranks:
        - execute as_server "kitpreview Diamond <player.name>"
        # Emerald rank (Left click - Buy)
        on player left clicks custom_buy_interface_ranks_item_rank_emerald in custom_buy_interface_ranks:
        - narrate "<proc[custom_buy_interface_ranks_narrate_link].context[emerald]>"
        # Emerald rank (Right click - Preview kit)
        on player right clicks custom_buy_interface_ranks_item_rank_emerald in custom_buy_interface_ranks:
        - execute as_server "kitpreview Emerald <player.name>"
        # Token rank (Left click - Buy)
        on player left clicks custom_buy_interface_ranks_item_rank_token in custom_buy_interface_ranks:
        - narrate "<proc[custom_buy_interface_ranks_narrate_link].context[token]>"
        # Token rank (Right click - Preview kit)
        on player right clicks custom_buy_interface_ranks_item_rank_token in custom_buy_interface_ranks:
        - execute as_server "kitpreview Token <player.name>"
        # Ultimate rank (Left click - Buy)
        on player left clicks custom_buy_interface_ranks_item_rank_ultimate in custom_buy_interface_ranks:
        - narrate "<proc[custom_buy_interface_ranks_narrate_link].context[ultimate]>"
        # Ultimate rank (Right click - Preview kit)
        on player right clicks custom_buy_interface_ranks_item_rank_ultimate in custom_buy_interface_ranks:
        - execute as_server "kitpreview Ultimate <player.name>"
#
# A procedure, that determines the text narrated when a player wants to buy a rank.
# invoke using format: <proc[custom_buy_interface_ranks_narrate_link].context[coal]> WHERE "coal" is the rank.
#
custom_buy_interface_ranks_narrate_link:
    type: procedure
    definitions: rank
    script:
    - if <[rank].exists>:
        - choose <[rank]>:
            - case coal:
                - define link "https://genfire.tebex.io/checkout/packages/add/5129192/single"
                - define display_name "Coal"
            - case iron:
                - define link "https://genfire.tebex.io/checkout/packages/add/5129203/single"
                - define display_name "Iron"
            - case gold:
                - define link "https://genfire.tebex.io/checkout/packages/add/5129215/single"
                - define display_name "Gold"
            - case diamond:
                - define link "https://genfire.tebex.io/checkout/packages/add/5129216/single"
                - define display_name "Diamond"
            - case emerald:
                - define link "https://genfire.tebex.io/checkout/packages/add/5129220/single"
                - define display_name "Emerald"
            - case token:
                - define link "https://genfire.tebex.io/checkout/packages/add/5129221/single"
                - define display_name "Token"
            - case ultimate:
                - define link "https://genfire.tebex.io/checkout/packages/add/5158613/single"
                - define display_name "Ultimate"
        - define hover_msg "<&7>Donating is what allows us to run this server.<&nl><&6>Click here to go to the store."
        - determine "<&8>Gen<&6>Fire<&8> - <&6>Store<&nl><&7><&o>Thanks for considering donating!<&nl><&r><&6>Rank: <&e><[display_name]><&nl><element[<&a>Click here to continue].on_click[<[link]>].type[OPEN_URL].on_hover[<[hover_msg]>]>"
    - else:
        - determine ERROR_UNDEFINED_custom_buy_interface_ranks_narrate_link

#
# Keys category menu.
#
custom_buy_interface_keys:
    type: inventory
    inventory: chest
    title: Store -<&gt> Keys
    gui: true
    definitions:
      star key: <item[custom_buy_interface_keys_item_key_star]>
      star 3 keys: <item[custom_buy_interface_keys_item_key_star_3]>
      sea key: <item[custom_buy_interface_keys_item_key_sea]>
      sea 3 keys: <item[custom_buy_interface_keys_item_key_sea_3]>
      crystal key: <item[custom_buy_interface_keys_item_key_crystal]>
      crystal 3 keys: <item[custom_buy_interface_keys_item_key_crystal_3]>
      back button: <item[custom_buy_interface_keys_item_control_back]>
    size: 36
    procedural items:
    - define result <list>
    # Add some logic!
    - repeat 29:
        - define result:->:<item[gray_stained_glass_pane]>
    - determine <[result]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [star key] [star 3 keys] [sea key] [sea 3 keys] [crystal key] [crystal 3 keys] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [back button] [] [] [] []

# The back button displayed in the keys category.
custom_buy_interface_keys_item_control_back:
    type: item
    material: barrier
    display name: <&c><&l>Go back
    lore:
    - <&7>Choose another category.
# The displayed item representing 1x star key.
custom_buy_interface_keys_item_key_star:
    type: item
    material: nether_star
    display name: <&f>Star key <&8>(<&a>$3<&8>)
    lore:
    - <&7>This is a crate key, that can open the Star Crate in spawn.
    - ""
    - <&a>Left click to purchase
# The displayed item representing 3x star key.
custom_buy_interface_keys_item_key_star_3:
    type: item
    material: nether_star
    display name: <&8>3x <&f>Star key <&8>(<&a>$7<&8>)
    lore:
    - <&7>This is a crate key, that can open the Star Crate in spawn.
    - ""
    - <&a>Left click to purchase
# The displayed item representing 1x sea key.
custom_buy_interface_keys_item_key_sea:
    type: item
    material: heart_of_the_sea
    display name: <&9>Sea key <&8>(<&a>$5<&8>)
    lore:
    - <&7>This is a crate key, that can open the Sea Crate in spawn.
    - ""
    - <&a>Left click to purchase
# The displayed item representing 3x sea key.
custom_buy_interface_keys_item_key_sea_3:
    type: item
    material: heart_of_the_sea
    display name: <&8>3x <&9>Sea key <&8>(<&a>$12<&8>)
    lore:
    - <&7>This is a crate key, that can open the Sea Crate in spawn.
    - ""
    - <&a>Left click to purchase

# The displayed item representing 1x crystal key.
custom_buy_interface_keys_item_key_crystal:
    type: item
    material: amethyst_shard
    display name: <&d>Crystal key <&8>(<&a>$7<&8>)
    lore:
    - <&7>This is a crate key, that can open the Crystal Crate in spawn.
    - ""
    - <&a>Left click to purchase
# The displayed item representing 3x crystal key.
custom_buy_interface_keys_item_key_crystal_3:
    type: item
    material: amethyst_shard
    display name: <&8>3x <&d>Crystal key <&8>(<&a>$15<&8>)
    lore:
    - <&7>This is a crate key, that can open the Crystal Crate in spawn.
    - ""
    - <&a>Left click to purchase
# A world script, that detects when a player clicks a key in the keys category.
custom_buy_interface_keys_world_script:
    type: world
    events:
        # On player clicks on the back control button.
        on player clicks custom_buy_interface_keys_item_control_back in custom_buy_interface_keys:
        - inventory open d:custom_buy_interface_main
        # Star Key (x1) (Left click - Buy)
        on player left clicks custom_buy_interface_keys_item_key_star in custom_buy_interface_keys:
        - narrate "<proc[custom_buy_interface_keys_narrate_link].context[star]>"
        # Star Key (x3) (Left click - Buy)
        on player left clicks custom_buy_interface_keys_item_key_star_3 in custom_buy_interface_keys:
        - narrate "<proc[custom_buy_interface_keys_narrate_link].context[star_3]>"
        # Sea Key (x1) (Left click - Buy)
        on player left clicks custom_buy_interface_keys_item_key_sea in custom_buy_interface_keys:
        - narrate "<proc[custom_buy_interface_keys_narrate_link].context[sea]>"
        # Sea Key (x3) (Left click - Buy)
        on player left clicks custom_buy_interface_keys_item_key_sea_3 in custom_buy_interface_keys:
        - narrate "<proc[custom_buy_interface_keys_narrate_link].context[sea_3]>"
        # crystal Key (x1) (Left click - Buy)
        on player left clicks custom_buy_interface_keys_item_key_crystal in custom_buy_interface_keys:
        - narrate "<proc[custom_buy_interface_keys_narrate_link].context[crystal]>"
        # crystal Key (x3) (Left click - Buy)
        on player left clicks custom_buy_interface_keys_item_key_crystal_3 in custom_buy_interface_keys:
        - narrate "<proc[custom_buy_interface_keys_narrate_link].context[crystal_3]>"
custom_buy_interface_keys_narrate_link:
    type: procedure
    definitions: key
    script:
    - if <[key].exists>:
        - choose <[key]>:
            - case star:
                - define link "https://genfire.tebex.io/checkout/packages/add/5157116/single"
                - define display_name "Star"
            - case star_3:
                - define link "https://genfire.tebex.io/checkout/packages/add/5157117/single"
                - define display_name "Star (x3)"
            - case sea:
                - define link "https://genfire.tebex.io/checkout/packages/add/5157120/single"
                - define display_name "Sea"
            - case sea_3:
                - define link "https://genfire.tebex.io/checkout/packages/add/5157124/single"
                - define display_name "Sea (x3)"
            - case crystal:
                - define link "https://genfire.tebex.io/checkout/packages/add/5129220/single"
                - define display_name "Crystal"
            - case crystal_3:
                - define link "https://genfire.tebex.io/checkout/packages/add/5157194/single"
                - define display_name "Crystal (x3)"
        - define hover_msg "<&7>Donating is what allows us to run this server.<&nl><&6>Click here to go to the store."
        - determine "<&8>Gen<&6>Fire<&8> - <&6>Store<&nl><&7><&o>Thanks for considering donating!<&nl><&r><&6>Key: <&e><[display_name]><&nl><element[<&a>Click here to continue].on_click[<[link]>].type[OPEN_URL].on_hover[<[hover_msg]>]>"
    - else:
        - determine ERROR_UNDEFINED_custom_buy_interface_ranks_narrate_link