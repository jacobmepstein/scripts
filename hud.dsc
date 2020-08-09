hud_toggle:
    type: command
    name: hud
    description: Toggle display of the HUD.
    usage: /hud <&lt>enable/disable<&gt>
    permission: allodia.perm.hud
    tab completions:
        1: enable|disable
    script:
    - if <context.args.is_empty>:
        - narrate "<red>Improper usage. Use /hud <&lt>enable/disable<&gt>."
        - stop
    # could this next portion be better done with a choose/case layout?
    - if <context.args.get[1].contains_text[enable]>:
        - flag player hud_enabled:true
        - inject hud_enable
    - if <context.args.get[1].contains_text[disable]>:
        - flag player hud_enabled:false
        - inject hud_disable
    - else:
        - narrate "<red>Improper usage. Use /hud <&lt>enable/disable<&gt>."

hud_enable:
    type: task
    script:
    - bossbar create hud players:<player> title:"<&7><player.location.x.round_to[0]> <&f><&l><player.location.direction.char_at[1].to_uppercase> <&7><player.location.z.round_to[0]>"

hud_disable:
    type: task
    script:
    - bossbar remove hud

hud_updater:
    type: world
    debug: true
    events:
        on tick every:10:
        - if <player.flag[hud_enabled]>:
            - bossbar update hud players:<player> title:"<&7><player.location.x.round_to[0]> <&f><&l><player.location.direction.char_at[1].to_uppercase> <&7><player.location.z.round_to[0]>"
        - else:
            - stop

hud_on_first_join:
    type: world
    debug: true
    events:
        on player joins:
        - if !<player.has_flag[hud_enabled]>:
            - inject hud_enable
            - flag player hud_enabled:true
        - else:
            - stop
