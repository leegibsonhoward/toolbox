#!/bin/bash

# Minecraft server startup script
# Created by: Lee Howard, 1/13/2024
# Updated: 11/21/2026

minecraft_dir="$HOME/minecraft-server" 

server_jar="spigot-1.19.2.jar"

java_cmd="java -jar -Xms2G -Xmx2G $server_jar nogui"

tmux_cmd="tmux send-keys -t minecraft '$java_cmd' C-m"

if ! tmux ls 2>/dev/null | grep -q "minecraft"; then
    echo 'changing to minecraft directory'
    cd $minecraft_dir
    echo 'starting server in new session'
    tmux new-session -d -s minecraft
    eval "$tmux_cmd"
else
    if pgrep -fx "$java_cmd" 1>/dev/null; then
        echo 'server already running in existing session'
        echo "pid: ""$(pgrep -fx "$java_cmd")"
    else
        echo 'starting server in existing session'
        tmux send-keys -t minecraft 'cd $minecraft_dir' C-m
        eval "$tmux_cmd"
    fi
fi
