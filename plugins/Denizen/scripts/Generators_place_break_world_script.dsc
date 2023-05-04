gens:
    type: command
    name: gens
    description: <&e>See the islands generators.
    usage: /gens
    script:
    - inject can_player_place_generator
    - narrate "<&e>Money Gens<&co> <&7><proc[get_island_stats].context[money]>"
    - narrate "<&e>Token Gens<&co> <&7><proc[get_island_stats].context[token]>"
    - narrate "<&e>Sellchests<&co> <&7><proc[get_island_stats].context[sellchests]>"

generator_drop_world_script:
    type: world
    debug: false
    events:
        on delta time secondly every:3:
        - define islands_active:<list>
        - foreach <server.online_players> as:__player:
            - if <placeholder[bskyblock_on_island]>:
                - define islands_active:<-:<placeholder[bskyblock_visited_island_uuid]>
                - define islands_active:->:<placeholder[bskyblock_visited_island_uuid]>
        - foreach <[islands_active]> as:island:
            - run validate_island_settings def.island_uuid:<[island]>
            - if !<server.flag[island.<[island]>.settings.generators_active]||true>:
                # If the island has disabled generator drops, skip.
                - foreach next
            - foreach <server.flag[island.<[island]>.money]> as:generator:
                - if <[generator.location].chunk.is_loaded>:
                    - if <element[<[generator.location].material.name>].contains_all_text[<item[<[generator.drops]>_generator_1].material.name>]>:
                        - drop <[generator.location].above[1].center> <item[<[generator.drops]>].with[display_name=<[generator.displayname]>].with_flag[generator_drop:true]> quantity:<[generator.level]||1>
                    - else:
                        - define log_message "Invalid generator block, '<[generator.location].material.name>' doesn't equal '<item[<[generator.drops]>_generator_1].material.name>' location: <[generator.location]>"
                        - run add_to_log def.message:<[log_message]> def.format:default_log_format def.type:warning def.log_file:invalid_generators.txt
        on delta time secondly every:16:
        - define islands_active:<list>
        - foreach <server.online_players> as:__player:
            - if <placeholder[bskyblock_on_island]>:
                - define islands_active:<-:<placeholder[bskyblock_visited_island_uuid]>
                - define islands_active:->:<placeholder[bskyblock_visited_island_uuid]>
        - foreach <[islands_active]> as:island:
            - run validate_island_settings def.island_uuid:<[island]>
            - if !<server.flag[island.<[island]>.settings.generators_active]||true>:
                # If the island has disabled generator drops, skip.
                - foreach next
            - foreach <server.flag[island.<[island]>.token]> as:generator:
                - if <[generator.location].chunk.is_loaded>:
                    - if <element[<[generator.location].material.name>].contains_all_text[<item[<[generator.drops]>_generator_1].material.name>]>:
                        - drop <[generator.location].above[1].center> <item[<[generator.drops]>].with[display_name=<[generator.displayname]>].with_flag[token_generator_drop:true]> quantity:<[generator.level]||1>
                    - else:
                        - define log_message "Invalid generator block, '<[generator.location].material.name>' doesn't equal '<item[<[generator.drops]>_generator_1].material.name>' location: <[generator.location]>"
                        - run add_to_log def.message:<[log_message]> def.format:default_log_format def.type:warning def.log_file:invalid_generators.txt
            #- narrate <[island]> targets:<server.online_players>
validate_island_settings:
    type: task
    definitions: island_uuid
    debug: false
    script:
    - if !<server.has_flag[island.<[island_uuid]>.settings]> OR <server.flag[island.<[island_uuid]>.settings].size||<list.size>> < 7:
        # Setting the max island generators to 25 (default)
        - flag server island.<[island_uuid]>.settings.money_max:25
        # Setting the max island token generators to 6 (default)
        - flag server island.<[island_uuid]>.settings.token_max:6
        # Setting the max sellchests to 5 (default)
        - flag server island.<[island_uuid]>.settings.sellchests_max:5
        # Setting the max island level to 1 (default)
        - flag server island.<[island_uuid]>.settings.level:1
        # Setting the display_holograms to true (default)
        - flag server island.<[island_uuid]>.settings.display_holograms:true
        # Setting the generators_active to true (default)
        - flag server island.<[island_uuid]>.settings.generators_active:true
        # Setting the sellchests_active to true (default)
        - flag server island.<[island_uuid]>.settings.sellchests_active:true
        # Setting the upgrades to defaults:
        - flag server island.<[island_uuid]>.upgrades.max_generators.level:0
        - flag server island.<[island_uuid]>.upgrades.max_token_generators.level:0
        - flag server island.<[island_uuid]>.upgrades.team_size.level:0
        - flag server island.<[island_uuid]>.upgrades.team_multiplier.level:0
        - define log_message "<&a><[island_uuid]> settings was undefined, added default settings"
        - run add_to_log def.message:<[log_message]> def.format:island_log_format def.type:info def.log_file:island_manager.txt
    - else:
        - define log_message "<&e><[island_uuid]> is already defined, Doing nothing"
        - run add_to_log def.message:<[log_message]> def.format:island_log_format def.type:info def.log_file:island_manager.txt
add_to_log:
    type: task
    definitions: message|type|format|log_file
    debug: false
    script:
    - if <[message].exists>:
        - log "<element[<[message]>].format[<[format]||default_log_format>]>" type:<[type]||info> file:/script_logs/<[log_file]||fallback_log.txt>
default_log_format:
    type: format
    format: <&8><&lb><&c>DEFAULT<&8><&rb> <&f><[text]>
island_log_format:
    type: format
    debug: false
    format: <&8><&lb><&6>Island Console<&8><&rb> <&7><[text]>
Generators_place_break_world_script:
    type: world
    events:
        on player places item_flagged:generator:
        # Determine generator type
        - if <context.item_in_hand.has_flag[token]>:
            - define generator.type:token
            - if <server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.token].size||0> >= <server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.settings.token_max]||6>:
                - narrate format:generator_format "<&c>You've placed your max of <server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.token].size||0> token generators."
                - determine passively cancelled
                - stop
        - else:
            - define generator.type:money
            # If the limit has been reached.
            - if <server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.money].size||0> >= <server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.settings.money_max]||25>:
                - narrate format:generator_format "<&c>You've placed your max of <server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.money].size||0> generators."
                - determine passively cancelled
                - stop
        - if <context.location.material.direction.exists>:
            - if <context.location.material.direction> != Y:
                - adjustblock <context.location> direction:Y
        - run player_place_generator instantly def.player:<player> def.item:<context.item_in_hand> def.location:<context.location>
        on player breaks block location_flagged:generator:
        - run island_remove_generator def.island_uuid:<placeholder[bskyblock_visited_island_uuid]> def.generator_location:<context.location> def.generator_type:<context.location.flag[generator.type]> def.player:<player>
        # Make sure that no default block is being dropped.
        - determine NOTHING
        on player right clicks block location_flagged:generator:
        - inject can_player_place_generator
        - define island_uuid:<placeholder[bskyblock_visited_island_uuid]>
        - if <server.has_flag[island.<[island_uuid]>.money.<context.location>]>:
            - define generator_array:<server.flag[island.<[island_uuid]>.money.<context.location>]>
            #- narrate Money<&nl><[generator_array]>
            - if <[generator_array.level]||1> >= 3:
                - narrate format:generator_format "<&6>This generator is already in it's max level. <&8><&lb><&7>3/3<&8><&rb>"
                - stop
            - else:
                - flag player temp.selected_generator:<[generator_array]>
                - inventory open d:generator_upgrade_menu
        - else:
            - narrate format:generator_format "<&c>This generator can't be upgraded."
#
#!- Generator upgrade menu (RIGHT CLICKED)
#
generator_upgrade_menu:
    type: inventory
    inventory: chest
    title: Generator -<&gt> Upgrade
    gui: true
    definitions:
      upgrade button: generator_upgrade_menu_item_control_upgrade
      close button: generator_upgrade_menu_item_control_close
      background: generator_upgrade_menu_item_panels
    procedural items:
    - define result <list>
    # Add some logic!
    - determine <[result]>
    slots:
    - [background] [background] [background] [] [upgrade button] [] [background] [background] [background]
#
#!- Generator upgrade menu (RIGHT CLICKED) -> Items
#
generator_upgrade_menu_item_panels:
  type: item
  display name: <&0>[-]
  material: gray_stained_glass_pane
  lore:
  - <&0>[-]
generator_upgrade_menu_item_control_upgrade:
    type: item
    material: nether_star
    display name: <&6><&l>Upgrade generator
    lore:
    - <proc[generator_upgrade_menu_get_lore].context[generator_upgrade_menu_item_control_upgrade|<player>]>
generator_upgrade_menu_item_control_close:
    type: item
    material: barrier
    display name: <&c><&l>Close menu
    lore:
    - <&7>Click here to close the menu.
#
#!- Generator upgrade menu (RIGHT CLICKED) -> Upgrade -> World script
#
generator_upgrade_menu_world_script:
    type: world
    events:
        on player clicks generator_upgrade_menu_item_control_upgrade in generator_upgrade_menu:
        - ratelimit <player> 1s
        - define island_uuid:<placeholder[bskyblock_visited_island_uuid]>
        - define generator_array:<player.flag[temp.selected_generator]>
        - if <server.has_flag[island.<[island_uuid]>.money.<[generator_array.location]>]>:
            - define generator_price:<script[generator_price_data].data_key[<[generator_array.drops]>]>
            - define upgrade_price:<[generator_price].mul[0.5].mul[<[generator_array.level]>]>
            - if <player.money> >= <[upgrade_price]>:
                - money take quantity:<[upgrade_price]> players:<player>
                - flag server island.<[island_uuid]>.money.<[generator_array.location]>.level:+:1
                - run generator_update_hologram def.generator_location:<[generator_array.location]> def.generator_level:<[generator_array.level].add[1]> def.generator_displayname:<[generator_array.displayname]> def.island_uuid:<[island_uuid]>
                - narrate format:generator_format "<&e>Successfully upgraded your <[generator_array.displayname]><&e> Generator."
                - inventory close
            - else:
                - narrate format:generator_format "<&c>You can't afford this upgrade."
        - else:
            - narrate format:generator_format "<&c>Unable to find generator, try again."
            - inventory close
#
#!- Generator upgrade menu (RIGHT CLICKED) -> Items -> Get lore -> Procedure
#
generator_upgrade_menu_get_lore:
    type: procedure
    definitions: item|player
    script:
    - if <[item].exists> && <[player].exists>:
        - choose <[item]>:
            - case generator_upgrade_menu_item_control_upgrade:
                - define generator_array:<[player].flag[temp.selected_generator]>
                - define generator_price:<script[generator_price_data].data_key[<[generator_array.drops]>]>
                - define upgrade_price:<[generator_price].mul[0.5].mul[<[generator_array.level]>]>
                - determine "<&e>Click here to upgrade<&nl><&7>your generator from<&nl><&7>level <&b><[generator_array.level]> <&7>to <&b><[generator_array.level].add[1]><&7>.<&nl><&a>$<[upgrade_price]>"
            - default:
                - determine "<&c>ERROR<&co> Invalid lore (<&f><[item]||undefined><&c>)"
    - else:
        - determine ERROR_UNDEFINED_generator_upgrade_menu_get_lore

#
#!- Task that places a generator.
#
player_place_generator:
    type: task
    definitions: item|player|location
    script:
    - if !<[item].exists> OR !<[player].exists>:
        - narrate "The item or player is not defined, quitting...<&nl>Debug: player_place_generator<&nl>Please report this to a staff member."
        - stop
    - inject can_player_place_generator
    - define generator.block:<[item].material.name>
    - define generator.drops:<[item].flag[material]>
    - define generator.level:<[item].flag[level]>
    - define generator.displayname:<[item].flag[displayname]>
    # Determine generator type
    - if <[item].has_flag[token]>:
        - define generator.type:token
    - else:
        - define generator.type:money
    - define generator.location:<[location]>
    - flag <[location]> generator.type:<[generator.type]>
    - run island_add_generator def.island_uuid:<placeholder[bskyblock_visited_island_uuid]> def.generator_location:<[generator.location]> def.generator_type:<[generator.type]> def.generator_block:<[generator.block]> def.generator_drops:<[generator.drops]> def.generator_level:<[generator.level]> def.generator_displayname:<[generator.displayname]>
    - narrate format:generator_format "<&e>Placed a <[generator.displayname]> <&8>(<&7>Lvl. <[generator.level]><&8>) <&e>generator." targets:<[player]>
generator_format:
    type: format
    format: <&8><&lb><&6>GenFire<&8><&rb> <&7><[text]>
island_add_generator:
    type: task
    definitions: island_uuid|generator_type|generator_location|generator_block|generator_drops|generator_level|generator_displayname
    script:
    - if !<[island_uuid].exists>:
        - narrate "The island_uuid is not defined!"
        - stop
    - define generator.block:<[generator_block]>
    - define generator.drops:<[generator_drops]>
    - define generator.level:<[generator_level]>
    - define generator.displayname:<[generator_displayname]>
    - define generator.location:<[generator_location]>
    - flag server island.<[island_uuid]>.<[generator_type]>.<[generator_location]>:<[generator]>
    - run generator_update_hologram def.generator_location:<[generator_location]> def.generator_level:<[generator.level]> def.generator_displayname:<[generator.displayname]> def.island_uuid:<[island_uuid]>
generator_update_hologram:
    type: task
    definitions: generator_location|generator_level|generator_displayname|island_uuid
    script:
    - if <[generator_location].exists> && <[island_uuid].exists> && <[generator_location].chunk.is_loaded||false>:
        # Check if the generator already have holograms:
        - if <server.has_flag[island.<[island_uuid]>.holograms.<[generator_location]>]>:
            - foreach <server.flag[island.<[island_uuid]>.holograms.<[generator_location]>]> as:entity_hologram key:line:
                - if <entity[<[entity_hologram]>].exists>:
                    - remove <[entity_hologram]>
                    - flag server island.<[island_uuid]>.holograms.<[generator_location]>.<[line]>:!
        - if <server.flag[island.<player.flag[island_gui_main.uuid]>.settings.display_holograms]||true> && <[generator_location].has_flag[generator]||false> && <[generator_level].exists> && <[generator_displayname].exists>:
            - spawn generator_hologram_entity[custom_name=<&6><[generator_displayname]>] <[generator_location].center.above[1]> persistent save:hologram1
            - flag server island.<[island_uuid]>.holograms.<[generator_location]>.1:<entry[hologram1].spawned_entity>
            - spawn generator_hologram_entity[custom_name=<&0>(<&f>Lvl.<&sp><[generator_level]><&0>)] <[generator_location].center.above[0.75]> persistent save:hologram2
            - flag server island.<[island_uuid]>.holograms.<[generator_location]>.2:<entry[hologram2].spawned_entity>
generator_hologram_entity:
    type: entity
    debug: true
    entity_type: armor_stand
    mechanisms:
        marker: true
        visible: false
        custom_name_visible: true
        invulnerable: true
        gravity: false
island_remove_generator:
    type: task
    definitions: island_uuid|generator_type|generator_location|player
    script:
    - if !<[island_uuid].exists>:
        - narrate "The island_uuid is not defined!"
        - stop
    - flag <[generator_location]> generator:!
    - run generator_update_hologram def.island_uuid:<[island_uuid]> def.generator_location:<[generator_location]>
    # Save the generators properties, to give it to the player.
    - if <server.has_flag[island.<[island_uuid]>.<[generator_type]>.<[generator_location]>]>:
        - define generator_array:<server.flag[island.<[island_uuid]>.<[generator_type]>.<[generator_location]>]>
        - define generator_drops:<[generator_array.drops]>
        - define generator_displayname:<[generator_array.displayname]>
        - define generator_level:<[generator_array.level]>
        #- narrate <[generator_array]> targets:<server.match_player[JeppeDK]>
    # Remove the generator from the islands generator list.
    - flag server island.<[island_uuid]>.<[generator_type]>.<[generator_location]>:!
    # Give the player the generator, if a player is set.
    - if <[player].exists>:
        - give <proc[create_generator_item].context[<[generator_drops]>|<[generator_level]>]> to:<[player].inventory> quantity:1
    - narrate format:generator_format "<&e>Broke a <[generator_displayname]> <&8>(<&7>Lvl. <[generator_level]><&8>) <&e>generator." targets:<[player]>
create_generator_item:
    type: procedure
    definitions: generator_drops|generator_level
    script:
    - if <[generator_drops].exists>:
        - if !<[generator_level].exists>:
            - define generator_level:1
        - if <item[<[generator_drops]>_generator_<[generator_level]>].exists>:
            - determine <item[<[generator_drops]>_generator_<[generator_level]>]>
        - else:
            - determine "<&c>Unable to create generator, invalid item drop."
    - else:
        - determine "ERROR_UNDEFINED_create_generator_item"
can_player_place_generator:
    type: task
    script:
    - if !<placeholder[bskyblock_on_island]>:
        - narrate format:generator_format "<&c>You don't have permissions on this island!"
        - determine passively cancelled
        - stop
    #Otherwise, it'll just let the player place the block.

get_island_stats:
    type: procedure
    debug: false
    definitions: value
    script:
    - choose <[value]>:
        - case money:
            - determine "<&7><server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.money].size||0><&8>/<server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.settings.money_max]||...>"
        - case token:
            - determine "<&7><server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.token].size||0><&8>/<server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.settings.token_max]||...>"
        - case level:
            - define max_island_level:1
            - determine "<&7><server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.settings.level]||0><&8>/<[max_island_level]>"
        - case sellchests:
            - determine "<&7><server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.sellchests].size||0><&8>/<server.flag[island.<placeholder[bskyblock_visited_island_uuid]>.settings.sellchests_max]||...>"
        - default:
            - determine "Not a valid context value."