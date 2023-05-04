# Server settings procedure
server_settings:
    type: procedure
    definitions: setting|player|value
    script:
    - choose <[setting]>:
        - case spawn_location:
            - if <[value].exists>:
                - flag server server.settings.spawn_location:<[value]>
                - narrate "<&a>Spawn location set to <[value].as[location].formatted>" targets:<[player]>
            - else:
                # Check if server has a spawn location
                - if <server.flag[server.settings.spawn_location].exists>:
                    - determine <server.flag[server.settings.spawn_location].as[location]>
                - else:
                    - determine <world[world].spawn_location>