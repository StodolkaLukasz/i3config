#!/bin/bash
function get_active_window() {
    printf "0x%08x" $(xdotool getactivewindow)
}

function get_current_opacity() {
    window="$1"
    opacity=$(xprop -id $window | grep _NET_WM_WINDOW_OPACITY | awk '{print $3}')
    if [ -z $opacity ]; then   
        opacity=0xffffffff
    fi
    echo $opacity
}

function set_opacity() {
    window=$1
    opacity=$2

    if (( opacity <= 0 )); then
        opacity=0
    elif (( opacity >= 0xffffffff )); then
        opacity=0xffffffff
    fi

    xprop -id $window -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY $opacity
}

function increase_opacity() {
    window=$(get_active_window)
    opacity=$(get_current_opacity $window)

    percentage=$((opacity*100/0xffffffff))

    new_opacity=$((percentage+10))
    new_opacity=$((new_opacity*0xffffffff/100))

    set_opacity $window $new_opacity 
}

function decrease_opacity() {
    window=$(get_active_window)
    opacity=$(get_current_opacity $window)

    percentage=$((opacity*100/0xffffffff))

    new_opacity=$((percentage-10))
    new_opacity=$((new_opacity*0xffffffff/100))

    set_opacity $window $new_opacity
}

function parse_args() {
    arg="$1"
    if [ -z "$arg" ]; then
        echo "Usage: $0 [ -i | -d ]"
    fi

    if [ "$arg" == '-i' ]; then
        increase_opacity
    elif [ "$arg" == '-d' ]; then
        decrease_opacity
    fi
}

parse_args $1
