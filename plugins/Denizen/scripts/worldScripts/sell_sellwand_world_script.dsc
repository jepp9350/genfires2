#
#!- Sell wands
#

# World script, that activates when a sellwand is used.
sell_sellwand_world_script:
    type: world
    events:
        on player right clicks chest with:item_flagged:sell-wand:
        - determine passively cancelled
        - inject can_player_place_generator
        - define multiplier:<context.item.flag[multiply]||1>
        - define capacity:<context.item.flag[capacity]||0>
        - inventory flag slot:hand capacity:<[capacity].sub[1]> destination:<player.inventory>
        - inventory adjust slot:hand "lore:<&7>Can be used: <&8><[capacity].sub[1]> times<&nl><&7>Multiply: <&8><[multiplier]>" destination:<player.inventory>
        - narrate "<&6>Selling chest using sellwand.<&nl><&8>Multiplier: <&6><[multiplier]>"
        - run sell_inventory def.player:<player> def.inventory:<context.location.inventory> def.multiplier:<[multiplier]>
        - if <[capacity]> <= 1:
            - take iteminhand
            - narrate "<&c>Sellwand broke!" targets:<player>
