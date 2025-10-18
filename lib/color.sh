#!/usr/bin/env bash

validate_hex() {
    local hex="${1#\#}"
    if [[ "$hex" =~ ^([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$ ]]; then
        return 0
    else
        return 1
    fi
}

normalize_hex() {
    local hex="${1#\#}"
    if [[ "$hex" =~ ^[0-9A-Fa-f]{3}$ ]]; then
        printf "%02x%02x%02x" $((16#${hex:0:1} * 17)) $((16#${hex:1:1} * 17)) $((16#${hex:2:1} * 17))
    else
        printf "%s" "$hex"
    fi
}

hex_to_rgb() {
    local hex
    hex="$(normalize_hex "$1")"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))
    printf "%d;%d;%d" "$r" "$g" "$b"
}

hex_to_ansi256() {
    local hex
    hex="$(normalize_hex "$1")"
    local r=$((16#${hex:0:2}))
    local g=$((16#${hex:2:2}))
    local b=$((16#${hex:4:2}))

    local r6=$(( (r * 5 + 127) / 255 ))
    local g6=$(( (g * 5 + 127) / 255 ))
    local b6=$(( (b * 5 + 127) / 255 ))

    local index=$((16 + 36 * r6 + 6 * g6 + b6))
    printf "%d" "$index"
}

rgb_to_hex() {
    local r=$1
    local g=$2
    local b=$3
    printf "%02x%02x%02x" "$r" "$g" "$b"
}

rgb_to_ansi256() {
    local r=$1
    local g=$2
    local b=$3
    local hex
    hex=$(rgb_to_hex "$r" "$g" "$b")
    hex_to_ansi256 "$hex"
}

ansi256_to_rgb() {
    local idx=$1
    local r g b
    if (( idx >= 16 && idx <= 231 )); then
        local v=$((idx - 16))
        local r6=$((v / 36))
        local g6=$(((v % 36) / 6))
        local b6=$((v % 6))
        r=$((r6 * 51))
        g=$((g6 * 51))
        b=$((b6 * 51))
    elif (( idx >= 232 && idx <= 255 )); then
        local gray=$((8 + (idx - 232) * 10))
        r=$gray; g=$gray; b=$gray
    else
        case $idx in
            0) r=0; g=0; b=0 ;;
            1) r=128; g=0; b=0 ;;
            2) r=0; g=128; b=0 ;;
            3) r=128; g=128; b=0 ;;
            4) r=0; g=0; b=128 ;;
            5) r=128; g=0; b=128 ;;
            6) r=0; g=128; b=128 ;;
            7) r=192; g=192; b=192 ;;
            8) r=128; g=128; b=128 ;;
            9) r=255; g=0; b=0 ;;
            10) r=0; g=255; b=0 ;;
            11) r=255; g=255; b=0 ;;
            12) r=0; g=0; b=255 ;;
            13) r=255; g=0; b=255 ;;
            14) r=0; g=255; b=255 ;;
            15) r=255; g=255; b=255 ;;
            *) r=0; g=0; b=0 ;;
        esac
    fi
    printf "%d %d %d" "$r" "$g" "$b"
}

sgr_to_rgb() {
    local code=$1
    case $code in
        30) printf "0 0 0" ;;
        31) printf "205 0 0" ;;
        32) printf "0 205 0" ;;
        33) printf "205 205 0" ;;
        34) printf "0 0 238" ;;
        35) printf "205 0 205" ;;
        36) printf "0 205 205" ;;
        37) printf "229 229 229" ;;
        90) printf "128 128 128" ;;
        91) printf "255 0 0" ;;
        92) printf "0 255 0" ;;
        93) printf "255 255 0" ;;
        94) printf "92 92 255" ;;
        95) printf "255 0 255" ;;
        96) printf "0 255 255" ;;
        97) printf "255 255 255" ;;
        *) return 1 ;;
    esac
}

numeric_to_rgb() {
    local n=$1
    if (( n >= 30 && n <= 37 )) || (( n >= 90 && n <= 97 )); then
        sgr_to_rgb "$n"
    elif (( n >= 0 && n <= 255 )); then
        ansi256_to_rgb "$n"
    else
        return 1
    fi
}
