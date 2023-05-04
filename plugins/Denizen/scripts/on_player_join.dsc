on_player_join_event:
    type: world
    events:
        on player joins:
        # Set the players location to the spawn location of the world
        #- execute as_player "spawn"
        # If the player dont have an island, create one
        - if !<placeholder[bskyblock_has_island]>:
            - run new_player_task def.player:<player>
new_player_task:
    type: task
    definitions: player
    script:
        # Set the players location to the spawn location of the world
        - adjust <[player]> location:<proc[server_settings].context[spawn_location|<player>]>
        # If the player dont have an island, create one
        - execute as_player  "is create default" silent
        # Teleport the player to his island
        - execute as_player "is home" silent
        # Show the player a welcome message
        - narrate "<&a>Welcome to the server!<&nl><&a>Here is your island!" targets:<[player]>
        # Show every player on the server a message that a new player has joined
        - narrate "<&a>New player joined the server!<&nl><&a>Player: <&e><[player].name>" targets:<server.online_players>