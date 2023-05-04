sell_get_item_value:
    type: procedure
    definitions: item
    script:
    - if <[item].exists>:
        - if <[item].has_flag[generator_drop]>:
            - determine <script[item_worth_data].data_key[<[item].material.name>]||0>
        - else:
            - determine 0
    - else:
        - determine ERR_ITEM_UNDEFINED_sell_get_item_value
    - determine true