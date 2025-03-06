socket=$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock

# wait till socket comes online
while [[ ! -e $(ls $socket) ]]; do
    echo "Waiting for socket..."
    sleep 1
done

echo "Socket online"

# restart ignis when new monitor is added
function handle {
    if [[ ${1:0:24} == "monitorremoved>>FALLBACK" ]]; then
        ignis quit
        sleep 1
        ignis init
    fi
}

socat - "UNIX-CONNECT:$socket" | while read -r line; do
    handle "$line"
done
