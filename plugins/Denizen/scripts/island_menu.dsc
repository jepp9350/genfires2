team_command:
    type: command
    name: team
    description: Does something
    usage: /team <&lt>arg<&gt>
    script:
    - if <placeholder[bskyblock_on_island]||false>:
        # If the player is a part of the island.
        - flag <player> island_gui_main.uuid:<placeholder[bskyblock_visited_island_uuid]>
        - flag <player> island_gui_main.name:<placeholder[bskyblock_visited_island_name]>
        - flag <player> island_gui_main.owner:<server.match_offline_player[<placeholder[bskyblock_visited_island_owner]>]>
        - flag <player> island_gui_main.permission.owner:<player.flag[island_gui_main.owner].uuid.equals[<player.uuid>]||false>
        - inventory open d:island_gui_main
    - else:
        # If the player is not on an island, the player is a part of.
        - narrate format:team_format "<&c>You're not allowed to manage this island."
        - stop
team_format:
    type: format
    format: <&8><&lb><&6>Team<&8><&rb> <&7><[text]>
island_gui_main:
    type: inventory
    inventory: chest
    title: <player.flag[island_gui_main.name]||NULL_UNDEFINED_island_gui_main> -<&gt> Manage
    gui: true
    definitions:
      settings: <item[island_gui_main_item_settings]>
      team: <item[island_gui_main_item_team]>
      upgrades: <item[island_gui_main_item_upgrades]>
      stats: <item[island_gui_main_item_stats]>
      close button: <item[island_gui_main_item_control_close]>
    procedural items:
    - define result <list>
    # Add some logic!
    - determine <[result]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [settings] [] [upgrades] [] [team] [] [stats] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [close button] [] [] [] []
island_gui_main_item_control_close:
    type: item
    material: barrier
    display name: <&c><&l>Close menu
    lore:
    - <&7>Click here to close the menu.
island_gui_main_item_settings:
    type: item
    material: player_head
    display name: <&6><&l>Settings
    lore:
    - <proc[island_main_get_lore].context[island_gui_main_item_settings|<player>]>
    mechanisms:
        skull_skin: 04049c90-d3e9-4621-9caf-0000aaa27523|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZTRkNDliYWU5NWM3OTBjM2IxZmY1YjJmMDEwNTJhNzE0ZDYxODU0ODFkNWIxYzg1OTMwYjNmOTlkMjMyMTY3NCJ9fX0=
island_gui_main_item_stats:
    type: item
    material: player_head
    display name: <&6><&l>Statistics
    lore:
    - <proc[island_main_get_lore].context[island_gui_main_item_stats|<player>]>
    mechanisms:
        skull_skin: 04049c90-d3e9-4621-9caf-0000aaa24498|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvZDAxYWZlOTczYzU0ODJmZGM3MWU2YWExMDY5ODgzM2M3OWM0MzdmMjEzMDhlYTlhMWEwOTU3NDZlYzI3NGEwZiJ9fX0=
island_gui_main_item_upgrades:
    type: item
    material: player_head
    display name: <&6><&l>Upgrades
    lore:
    - <proc[island_main_get_lore].context[island_gui_main_item_upgrades|<player>]>
    mechanisms:
        skull_skin: 04049c90-d3e9-4621-9caf-00000aaa2293|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvMTcxZDg5NzljMTg3OGEwNTk4N2E3ZmFmMjFiNTZkMWI3NDRmOWQwNjhjNzRjZmZjZGUxZWExZWRhZDU4NTIifX19
island_gui_main_item_team:
    type: item
    material: player_head
    display name: <&6><&l>Team
    lore:
    - <proc[island_main_get_lore].context[island_gui_main_item_team|<player>]>
    mechanisms:
        skull_skin: 04049c90-d3e9-4621-9caf-0000aaa31961|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDFlMTM5YzVkYjU0OGY5YTNhNGZlZmE1YWRhM2ZiN2M0ZTY2ODA1Y2ZmNGI2Zjg2ZGNiNDgwNjJkZGI5MWM4ZSJ9fX0=
#
#!- Island manage (MAIN) GUI -> Procedure -> Get lore
#
island_main_get_lore:
    type: procedure
    definitions: item|player
    script:
    - if <[item].exists> && <[player].exists>:
        - define island_uuid:<[player].flag[island_gui_main.uuid]>
        - choose <[item]>:
            # If the item is change_name:
            - case island_gui_main_item_settings:
                - define description "<&7>The settings for this island.<&nl><&7>Island name<&co> <&6><[player].flag[island_gui_main.name]><&7>.<&nl><&7>Holograms<&co> <&6><proc[get_island_settings].context[display_holograms|<[island_uuid]>]><&nl><&7>Generators<&co> <&6><proc[get_island_settings].context[generators_active|<[island_uuid]>]><&nl><&7>Sellchests<&co> <&6><proc[get_island_settings].context[sellchests_active|<[island_uuid]>]>"
                - define note "<&a>Click to modify settings"
                - determine <[description]><&nl><&nl><[note]>
            - case island_gui_main_item_team:
                - define members:<&6>
                - foreach <placeholder[bskyblock_visited_island_members_list].split[,]||<list>> as:island_member_name:
                    - define "members:<[members]><&nl><&6>- <[island_member_name]>"
                - define description "<&7>The island team.<&nl><&7>Island members<&co> <&8><&lb><&7><placeholder[bskyblock_visited_island_members_count]>/<placeholder[bskyblock_visited_island_members_max]><&8><&rb><[members]>"
                - define note "<&a>Click to manage team (coming soon)"
                - determine <[description]><&nl><&nl><[note]>
            - case island_gui_main_item_upgrades:
                - define description "<&7>The upgrades for this island.<&nl><&7>Island upgrades<&co><&nl><&7>Team size<&co> <proc[island_upgrades_get_level].context[team_size|<[island_uuid]>]><&nl><&7>Generator slots<&co> <proc[island_upgrades_get_level].context[max_generators|<[island_uuid]>]><&nl><&7>Token gen slots<&co> <proc[island_upgrades_get_level].context[max_token_generators|<[island_uuid]>]><&nl><&7>Team multiplier<&co> <proc[island_upgrades_get_level].context[team_multiplier|<[island_uuid]>]>"
                - define note "<&a>Click to view upgrades (coming soon)"
                - determine <[description]><&nl><&nl><[note]>
            - default:
                - determine "<&c>ERROR<&co> Invalid lore (<&f><[item]||undefined><&c>)"
    - else:
        - determine ERROR_UNDEFINED_island_settings_get_lore
#
#!- Island -> Upgrades -> Procedure -> Get levels
#
island_upgrades_get_level:
    type: procedure
    definitions: upgrade|island_uuid
    script:
    - if <[upgrade].exists> && <[island_uuid].exists>:
        - choose <[upgrade]>:
            - case team_size:
                - define max_level:3
                - determine "<&8><&lb><&7><server.flag[island.<[island_uuid]>.upgrades.team_size.level]||NULL_UNDEFINED_island_upgrades_get_level_team_size>/<[max_level]><&8><&rb>"
            - case max_generators:
                - define max_level:3
                - determine "<&8><&lb><&7><server.flag[island.<[island_uuid]>.upgrades.max_generators.level]||NULL_UNDEFINED_island_upgrades_get_level_max_generators>/<[max_level]><&8><&rb>"
            - case max_token_generators:
                - define max_level:3
                - determine "<&8><&lb><&7><server.flag[island.<[island_uuid]>.upgrades.max_token_generators.level]||NULL_UNDEFINED_island_upgrades_get_level_max_token_generators>/<[max_level]><&8><&rb>"
            - case team_multiplier:
                - define max_level:3
                - determine "<&8><&lb><&7><server.flag[island.<[island_uuid]>.upgrades.team_multiplier.level]||NULL_UNDEFINED_island_upgrades_get_level_team_multiplier>/<[max_level]><&8><&rb>"
            - default:
                - determine "Not a valid context value."
    - determine true
get_island_settings:
    type: procedure
    definitions: setting|island_uuid
    script:
    - if <[setting].exists> && <[island_uuid].exists>:
        - choose <[setting]>:
            - case display_holograms:
                - if <server.flag[island.<[island_uuid]>.settings.display_holograms]||true>:
                    - determine <&a>Enabled
                - else:
                    - determine <&c>Disabled
            - case generators_active:
                - if <server.flag[island.<[island_uuid]>.settings.generators_active]||true>:
                    - determine <&a>Enabled
                - else:
                    - determine <&c>Disabled
            - case sellchests_active:
                - if <server.flag[island.<[island_uuid]>.settings.sellchests_active]||true>:
                    - determine <&a>Enabled
                - else:
                    - determine <&c>Disabled
    - else:
        - determine ERROR_INVALID_UNDEFINED_get_island_settings
#
#!- Island manage GUI -> World script.
#
island_gui_main_world_script:
    type: world
    events:
        on player clicks island_gui_main_item_control_close in island_gui_main:
        - inventory close
        on player clicks island_gui_main_item_settings in island_gui_main:
        - inventory open d:island_gui_settings

#
#!- Island manage GUI -> Settings
#
island_gui_settings:
    type: inventory
    inventory: chest
    title: <player.flag[island_gui_main.name]||NULL_UNDEFINED_island_gui_main> -<&gt> Settings
    gui: true
    definitions:
      toggle holograms: <item[island_gui_settings_item_toggle_holograms]>
      change name: <item[island_gui_settings_item_change_name]>
      toggle generator drops: <item[island_gui_settings_item_toggle_generator_drops]>
      toggle sellchests: <item[island_gui_settings_item_toggle_sellchests]>
      back button: <item[island_gui_settings_item_control_back]>
    procedural items:
    - define result <list>
    # Add some logic!
    - determine <[result]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [change name] [] [toggle holograms] [] [toggle generator drops] [] [toggle sellchests] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [back button] [] [] [] []
island_gui_settings_item_control_back:
    type: item
    material: barrier
    display name: <&c><&l>Back
    lore:
    - <&7>Click here to go back.
island_gui_settings_item_toggle_holograms:
    type: item
    material: player_head
    display name: <&6><&l>Toggle holograms
    lore:
    - <proc[island_settings_get_lore].context[island_gui_settings_item_toggle_holograms|<player>]>
    mechanisms:
        skull_skin: <proc[get_true_false_skull_skin].context[<server.flag[island.<player.flag[island_gui_main.uuid]>.settings.display_holograms]||undefined>]>
island_gui_settings_item_change_name:
    type: item
    material: name_tag
    display name: <&6><&l>Change island name
    lore:
    - <proc[island_settings_get_lore].context[island_gui_settings_item_change_name|<player>]>
island_gui_settings_item_toggle_generator_drops:
    type: item
    material: player_head
    display name: <&6><&l>Toggle generator drops
    lore:
    - <proc[island_settings_get_lore].context[island_gui_settings_item_toggle_generator_drops|<player>]>
    mechanisms:
        skull_skin: <proc[get_true_false_skull_skin].context[<server.flag[island.<player.flag[island_gui_main.uuid]>.settings.generators_active]||undefined>]>
island_gui_settings_item_toggle_sellchests:
    type: item
    material: player_head
    display name: <&6><&l>Toggle sellchests
    lore:
    - <proc[island_settings_get_lore].context[island_gui_settings_item_toggle_sellchests|<player>]>
    mechanisms:
        skull_skin: <proc[get_true_false_skull_skin].context[<server.flag[island.<player.flag[island_gui_main.uuid]>.settings.sellchests_active]||undefined>]>
#
#!- Island manage (SETTINGS) GUI -> Procedure -> Get lore
#
island_settings_get_lore:
    type: procedure
    definitions: item|player
    script:
    - if <[item].exists> && <[player].exists>:
        - choose <[item]>:
            # If the item is change_name:
            - case island_gui_settings_item_change_name:
                # Check if the player is the owner of the island.
                - if <[player].flag[island_gui_main.permission.owner]>:
                    - define note "<&a>Click to change island name"
                - else:
                    - define note "<&c>Only <[player].flag[island_gui_main.owner].name> can change this."
                - define description "<&7>Change the island name.<&nl><&7>Currently<&co> <&6><[player].flag[island_gui_main.name]><&7>."
                - determine <[description]><&nl><&nl><[note]>
            # If the item is toggle_holograms:
            - case island_gui_settings_item_toggle_holograms:
                - if <server.flag[island.<[player].flag[island_gui_main.uuid]>.settings.display_holograms]||true>:
                    - define current_state "<&a>Enabled"
                - else:
                    - define current_state "<&c>Disabled"
                - define description "<&7>Toggle generator holograms.<&nl><&7>Currently<&co> <&6><[current_state]><&7>."
                - define note "<&a>Click to toggle"
                - determine <[description]><&nl><&nl><[note]>
            # If the item is toggle_generator_drops:
            - case island_gui_settings_item_toggle_generator_drops:
                - if <server.flag[island.<[player].flag[island_gui_main.uuid]>.settings.generators_active]||true>:
                    - define current_state "<&a>Enabled"
                - else:
                    - define current_state "<&c>Disabled"
                - define description "<&7>Toggle generator drops.<&nl><&7>Currently<&co> <&6><[current_state]><&7>."
                - define note "<&a>Click to toggle"
                - determine <[description]><&nl><&nl><[note]>
            # If the item is toggle_sellchests:
            - case island_gui_settings_item_toggle_sellchests:
                - if <server.flag[island.<[player].flag[island_gui_main.uuid]>.settings.sellchests_active]||true>:
                    - define current_state "<&a>Enabled"
                - else:
                    - define current_state "<&c>Disabled"
                - define description "<&7>Toggle sellchests.<&nl><&7>Currently<&co> <&6><[current_state]><&7>."
                - define note "<&a>Click to toggle"
                - determine <[description]><&nl><&nl><[note]>
            - default:
                - determine "<&c>ERROR<&co> Invalid lore (<&f><[item]||undefined><&c>)"
    - else:
        - determine ERROR_UNDEFINED_island_settings_get_lore
#
#!- Island manage (SETTINGS) GUI -> World script.
#
island_gui_settings_world_script:
    type: world
    events:
        on player clicks island_gui_settings_item_control_back in island_gui_settings:
        - inventory open d:island_gui_main
        on player clicks island_gui_settings_item_change_name in island_gui_settings:
        - if <player.flag[island_gui_main.permission.owner]>:
            - narrate format:team_format "To change the name of your island, <element[<&6><&l>Click here].on_click[/is setname ].type[SUGGEST_COMMAND].on_hover[<&7>Click here to change the island name.]><&7>."
            - inventory close
        - else:
            - narrate format:team_format "<&c>Only the owner if the island can change the name."
        on player clicks island_gui_settings_item_toggle_holograms in island_gui_settings:
        - if <server.flag[island.<player.flag[island_gui_main.uuid]>.settings.display_holograms]||false>:
            - flag server island.<player.flag[island_gui_main.uuid]>.settings.display_holograms:false
            - narrate format:team_format "<&c>Disabled <&7>generator holograms."
            - run island_update_all_generator_holograms def.island_uuid:<player.flag[island_gui_main.uuid]>
        - else:
            - flag server island.<player.flag[island_gui_main.uuid]>.settings.display_holograms:true
            - narrate format:team_format "<&a>Enabled <&7>generator holograms."
            - run island_update_all_generator_holograms def.island_uuid:<player.flag[island_gui_main.uuid]>
        # Reopen the inventory, to refresh it.
        - inventory open d:island_gui_settings
        on player clicks island_gui_settings_item_toggle_generator_drops in island_gui_settings:
        - if <server.flag[island.<player.flag[island_gui_main.uuid]>.settings.generators_active]||false>:
            - flag server island.<player.flag[island_gui_main.uuid]>.settings.generators_active:false
            - narrate format:team_format "<&c>Disabled <&7>generator drops."
        - else:
            - flag server island.<player.flag[island_gui_main.uuid]>.settings.generators_active:true
            - narrate format:team_format "<&a>Enabled <&7>generator drops."
        # Reopen the inventory, to refresh it.
        - inventory open d:island_gui_settings
        on player clicks island_gui_settings_item_toggle_sellchests in island_gui_settings:
        - if <server.flag[island.<player.flag[island_gui_main.uuid]>.settings.sellchests_active]||false>:
            - flag server island.<player.flag[island_gui_main.uuid]>.settings.sellchests_active:false
            - narrate format:team_format "<&c>Disabled <&7>sellchests."
        - else:
            - flag server island.<player.flag[island_gui_main.uuid]>.settings.sellchests_active:true
            - narrate format:team_format "<&a>Enabled <&7>sellchests."
        # Reopen the inventory, to refresh it.
        - inventory open d:island_gui_settings
island_update_all_generator_holograms:
    type: task
    definitions: island_uuid
    script:
    - if <[island_uuid].exists>:
        - foreach <server.flag[island.<[island_uuid]>.money]> as:generator key:generator_location:
            - run generator_update_hologram def.generator_location:<[generator.location]> def.generator_level:<[generator.level]> def.generator_displayname:<[generator.displayname]> def.island_uuid:<[island_uuid]>
get_true_false_skull_skin:
    type: procedure
    definitions: state
    script:
    - if <[state].exists>:
        - choose <[state]>:
            - case true:
                # Checkmark (GREEN) SKULL_SKIN
                - determine 04049c90-d3e9-4621-9caf-0000aaa21774|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvNDMxMmNhNDYzMmRlZjVmZmFmMmViMGQ5ZDdjYzdiNTVhNTBjNGUzOTIwZDkwMzcyYWFiMTQwNzgxZjVkZmJjNCJ9fX0=
            - case false:
                # X-MARK (RED) SKULL_SKIN
                - determine 04049c90-d3e9-4621-9caf-00000aaa9382|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvYmViNTg4YjIxYTZmOThhZDFmZjRlMDg1YzU1MmRjYjA1MGVmYzljYWI0MjdmNDYwNDhmMThmYzgwMzQ3NWY3In19fQ==
            - case default undefined:
                # QUESTIONMARK (YELLOW) SKULL_SKIN
                - determine 04049c90-d3e9-4621-9caf-000000aaa924|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGUxMDMwMTBkYmUyZGIyYWEwMzczZTYwYTgzZGRlNWJkY2I3NTg0OGM2ZmM3NzU4MzI2ZmVjZjczNDU5NDVlIn19fQ==
    - else:
        - determine 04049c90-d3e9-4621-9caf-000000aaa924|eyJ0ZXh0dXJlcyI6eyJTS0lOIjp7InVybCI6Imh0dHA6Ly90ZXh0dXJlcy5taW5lY3JhZnQubmV0L3RleHR1cmUvOGUxMDMwMTBkYmUyZGIyYWEwMzczZTYwYTgzZGRlNWJkY2I3NTg0OGM2ZmM3NzU4MzI2ZmVjZjczNDU5NDVlIn19fQ==