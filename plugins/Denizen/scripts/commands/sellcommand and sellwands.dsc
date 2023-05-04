sellchest_1:
    type: item
    material: chest
    display name: <&6>Sell chest
    lore:
    - <&7>Everything you put in this,
    - <&7>will sell automatically.
    flags:
        durability: 100
        multiply: 1

sellchest_world_script:
    type: world
    events:
        on player places sellchest_1:
        - inject can_player_place_generator
        - define island_uuid <placeholder[bskyblock_visited_island_uuid]>
        - narrate "Sellchest placed."
        - flag <context.location> sellchest:true
        - define sellchest.owner:<player>
        - define sellchest.location:<context.location>
        - define sellchest.durability:<context.item_in_hand.flag[durability]||100>
        - define sellchest.multiplier:<context.item_in_hand.flag[multiply]||1>
        - flag server island.<[island_uuid]>.sellchests.<[sellchest.location]>:<[sellchest]>
        - adjust <[sellchest.location]> "custom_name:<&6>Sell chest <&7>Uses: <[sellchest.durability]> <&7>Multiplier: <[sellchest.multiplier]>"
        on player breaks block location_flagged:sellchest:
        - define island_uuid <placeholder[bskyblock_visited_island_uuid]>
        - define location <context.location>
        - flag server island.<[island_uuid]>.sellchests.<[location]>:!
#
#!- Sellchests world script
#
sellchest_sell:
    type: world
    events:
        on delta time secondly every:10:
        - define islands_active:<list>
        - foreach <server.online_players> as:__player:
            - if <placeholder[bskyblock_on_island]>:
                - define islands_active:<-:<placeholder[bskyblock_visited_island_uuid]>
                - define islands_active:->:<placeholder[bskyblock_visited_island_uuid]>
        - foreach <[islands_active]> as:island:
            - run validate_island_settings def.island_uuid:<[island]>
            - if !<server.flag[island.<[island]>.settings.sellchests_active]||true>:
                # If the island has disabled generator drops, skip.
                - foreach next
            - foreach <server.flag[island.<[island]>.sellchests]||<list>> as:sellchest key:sellchest_location:
                - if <[sellchest_location].chunk.is_loaded>:
                    - if !<[sellchest_location].inventory.can_fit[<item[dirt].with_flag[unique_item:esvuhe893s]>]>:
                        - narrate format:sell_format "<&6>Resetting full sellchest..." targets:<[sellchest.owner]>
                        - run sell_inventory def.inventory:<[sellchest_location].inventory> def.player:<[sellchest.owner]> def.multiplier:<[sellchest.owner].flag[personal_multiplier]||1> def.silent:true
                        - if <[sellchest.durability].exists>:
                            - if <[sellchest.durability].sub[1]||100> >= 1:
                                - flag server island.<[island]>.sellchests.<[sellchest_location]>.durability:-:1
                                - adjust <[sellchest_location]> "custom_name:<&6>Sell chest <&7>Uses: <[sellchest.durability].sub[1]> <&7>Multiplier: <[sellchest.multiplier]>"
                            - if <[sellchest.durability].sub[1]> <= 0:
                                - adjust <[sellchest_location]> custom_name:Chest
                                - flag server island.<[island]>.sellchests.<[sellchest_location]>:!
                                - narrate format:sell_format "<&c>Sellchest broke." targets:<[sellchest.owner]>
                            - foreach <[sellchest_location].inventory.viewers> as:__player:
                                - inventory open d:<[sellchest_location].inventory||<inventory[air]>>
                    #- else:
                    #    - narrate "The sellchest is not full yet." targets:<[sellchest.owner]>
#
#!- Sell chat format
#
sell_format:
    type: format
    format: <&8><&lb><&6>Sell<&8><&rb><&co><&sp><&e><[text]>
#
#!- /Sell command
#
sell_command:
    type: command
    name: csell
    description: <&e>Sell your generator drops.
    usage: /csell <&lt>all|hand<&gt>
    tab completions:
            1: all|hand
    script:
    - if <context.args.get[1].exists>:
        - define type:<context.args.get[1]>
    - else:
        - define type:all
    - choose <[type]>:
        - case hand:
            - narrate format:sell_format "Selling hand."
            - run sell_task def.type:hand def.player:<player>
        - case all:
            - narrate format:sell_format "Selling all generator drops."
            - run sell_task def.type:all def.player:<player>
        - default:
            - narrate format:sell_format "<&c>Invalid argument. <&7>/sell (hand|all)"
sell_task:
    type: task
    definitions: type|player
    script:
    - choose <[type]||default>:
        - case hand:
            - if <[player].exists> && <[player].is_player||false>:
                - define worth:<proc[sell_get_item_value].context[<[player].item_in_hand>]>
                - define quantity:<[player].item_in_hand.quantity>
                - if <[worth]> >= 1:
                    - define total_worth:<[worth].mul[<[quantity]>]>
                    - define total_worth:*:<player.flag[personal_multiplier]||1>
                    - narrate format:sell_format "Sold hand for <[total_worth]>"
                    - take iteminhand quantity:<[quantity]> from:<[player].inventory>
                    - money give quantity:<[total_worth]> players:<[player]>
                - else:
                    - narrate format:sell_format "<&c>This item can't be sold."
            - else:
                - narrate format:sell_format "<&c>Invalid or missing player."
        - case all:
            - if <[player].exists> && <[player].is_player||false>:
                - run sell_inventory def.inventory:<[player].inventory> def.player:<[player]> def.multiplier:<player.flag[personal_multiplier]||1>
        - case default:
            - narrate format:sell_format "<&c>Invalid argument, type missing."
sell_inventory:
    type: task
    definitions: inventory|player|multiplier|silent
    script:
    - define items_sold:<list>
    - define token_items_sold:<list>
    - if <[inventory].exists> && <[player].exists>:
        # money drops
        - foreach <[inventory].map_slots.filter_tag[<[filter_value].has_flag[generator_drop]>]> as:content key:slot:
            - define quantity:<[content].quantity>
            - define worth:<proc[sell_get_item_value].context[<[content]>]>
            - if <[worth]> > 0:
                - define worth_total:<[worth].mul[<[quantity]>]>
                - define worth_total:*:<[multiplier]||1>
                - if !<[items_sold.<[content].display>].exists>:
                    - define items_sold.<[content].display>.quantity:0
                    - define items_sold.<[content].display>.total_worth:0
                - define items_sold.<[content].display>.quantity:+:<[quantity]>
                - define items_sold.<[content].display>.total_worth:+:<[worth_total]>
                - take slot:<[slot]> quantity:<[quantity]> from:<[inventory]>
                - money give quantity:<[worth_total]> players:<[player]>
        # token drops
        - foreach <[inventory].map_slots.filter_tag[<[filter_value].has_flag[token_generator_drop]>]> as:content key:slot:
            - define quantity:<[content].quantity>
            - define worth:<proc[sell_get_token_item_value].context[<[content]>]>
            - if <[worth]> > 0:
                - define worth_total:<[worth].mul[<[quantity]>]>
                - define worth_total:*:<[multiplier]||1>
                - if !<[token_items_sold.<[content].display>].exists>:
                    - define token_items_sold.<[content].display>.quantity:0
                    - define token_items_sold.<[content].display>.total_worth:0
                - define token_items_sold.<[content].display>.quantity:+:<[quantity]>
                - define token_items_sold.<[content].display>.total_worth:+:<[worth_total]>
                - take slot:<[slot]> quantity:<[quantity]> from:<[inventory]>
                - flag <player> tokens:+:<[worth_total]> players:<[player]>
        - define total_profit_money:0
        - define total_profit_tokens:0
        # money
        - foreach <[items_sold]> as:items_sold key:item:
            - define total_profit_money:+:<[items_sold.total_worth]>
            - narrate "<[item]> <&7>(<&8>x<[items_sold.quantity]><&7>) » <&a>$<[items_sold.total_worth]>" targets:<[player]>
        # token
        - foreach <[token_items_sold]> as:items_sold key:item:
            - define total_profit_tokens:+:<[items_sold.total_worth]>
            - narrate "<[item]> <&7>(<&8>x<[items_sold.quantity]><&7>) » <&b>⛁<[items_sold.total_worth]>" targets:<[player]>
        - if <[items_sold].size> <= 0 && !<[silent]||false> && <[token_items_sold].size> <= 0:
            - narrate "<&c>Nothing to sell..." targets:<[player]>
        - else:
            - narrate "<&6>Total<&co> <&a>$<[total_profit_money]> <&8>| <&b>⛁<[total_profit_tokens]>" targets:<[player]>


