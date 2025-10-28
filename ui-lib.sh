#!/bin/bash
# UI Library for Beautiful Shell Scripts
# Source this file: source ui-lib.sh

# Color definitions
export COLOR_RESET='\033[0m'
export COLOR_BOLD='\033[1m'
export COLOR_DIM='\033[2m'
export COLOR_RED='\033[31m'
export COLOR_GREEN='\033[32m'
export COLOR_YELLOW='\033[33m'
export COLOR_BLUE='\033[34m'
export COLOR_MAGENTA='\033[35m'
export COLOR_CYAN='\033[36m'
export COLOR_WHITE='\033[37m'
export COLOR_BG_RED='\033[41m'
export COLOR_BG_GREEN='\033[42m'
export COLOR_BG_YELLOW='\033[43m'
export COLOR_BG_BLUE='\033[44m'

# Unicode symbols
export SYMBOL_CHECK="✓"
export SYMBOL_CROSS="✗"
export SYMBOL_INFO="ℹ"
export SYMBOL_WARN="⚠"
export SYMBOL_ARROW="→"
export SYMBOL_BULLET="•"
export SYMBOL_STAR="★"
export SYMBOL_ROCKET="🚀"
export SYMBOL_PACKAGE="📦"
export SYMBOL_CLEAN="🧹"
export SYMBOL_FIRE="⚡"
export SYMBOL_BEER="🍺"
export SYMBOL_WRENCH="🔧"
export SYMBOL_TRASH="🗑️"
export SYMBOL_CLIPBOARD="📋"

# Spinner frames
SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
SPINNER_PID=""

# Terminal width
TERM_WIDTH=$(tput cols 2>/dev/null || echo 80)

# Print functions
print_header() {
    local text="$1"
    local width=$((TERM_WIDTH - 4))
    echo -e "\n${COLOR_BOLD}${COLOR_CYAN}╔$(printf '═%.0s' $(seq 1 $width))╗${COLOR_RESET}"
    printf "${COLOR_BOLD}${COLOR_CYAN}║${COLOR_RESET} ${COLOR_BOLD}%-${width}s${COLOR_CYAN}║${COLOR_RESET}\n" "$text"
    echo -e "${COLOR_BOLD}${COLOR_CYAN}╚$(printf '═%.0s' $(seq 1 $width))╝${COLOR_RESET}\n"
}

print_section() {
    local icon="$1"
    local text="$2"
    echo -e "\n${COLOR_BOLD}${COLOR_BLUE}${icon} ${text}${COLOR_RESET}"
    echo -e "${COLOR_DIM}$(printf '─%.0s' $(seq 1 $((TERM_WIDTH - 2))))${COLOR_RESET}"
}

print_success() {
    local text="$1"
    echo -e "${COLOR_GREEN}${COLOR_BOLD}  ${SYMBOL_CHECK}${COLOR_RESET} ${COLOR_GREEN}${text}${COLOR_RESET}"
}

print_error() {
    local text="$1"
    echo -e "${COLOR_RED}${COLOR_BOLD}  ${SYMBOL_CROSS}${COLOR_RESET} ${COLOR_RED}${text}${COLOR_RESET}"
}

print_warning() {
    local text="$1"
    echo -e "${COLOR_YELLOW}${COLOR_BOLD}  ${SYMBOL_WARN}${COLOR_RESET} ${COLOR_YELLOW}${text}${COLOR_RESET}"
}

print_info() {
    local text="$1"
    echo -e "${COLOR_CYAN}${COLOR_BOLD}  ${SYMBOL_INFO}${COLOR_RESET} ${COLOR_CYAN}${text}${COLOR_RESET}"
}

print_step() {
    local text="$1"
    echo -e "${COLOR_WHITE}  ${COLOR_DIM}${SYMBOL_ARROW}${COLOR_RESET} ${text}"
}

# Spinner functions
start_spinner() {
    local message="$1"
    local pid=$2

    tput civis # Hide cursor

    (
        local i=0
        while kill -0 $pid 2>/dev/null; do
            printf "\r${COLOR_CYAN}  ${SPINNER_FRAMES[$i]}${COLOR_RESET} ${message}..."
            i=$(( (i + 1) % ${#SPINNER_FRAMES[@]} ))
            sleep 0.1
        done
    ) &

    SPINNER_PID=$!
}

stop_spinner() {
    local success=$1
    local message="$2"

    if [ ! -z "$SPINNER_PID" ]; then
        kill $SPINNER_PID 2>/dev/null
        wait $SPINNER_PID 2>/dev/null
    fi

    printf "\r\033[K" # Clear line

    if [ "$success" = "0" ]; then
        print_success "$message"
    else
        print_error "$message"
    fi

    tput cnorm # Show cursor
    SPINNER_PID=""
}

# Progress bar
show_progress() {
    local current=$1
    local total=$2
    local label="$3"
    local width=40
    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    local bar=""
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done

    printf "\r${COLOR_CYAN}  ${bar}${COLOR_RESET} ${COLOR_BOLD}%3d%%${COLOR_RESET} ${label}" $percentage

    if [ $current -eq $total ]; then
        echo ""
    fi
}

# Execute command with visual feedback
execute_with_feedback() {
    local message="$1"
    local success_msg="$2"
    local error_msg="$3"
    shift 3
    local cmd="$@"

    # Run command in background
    eval "$cmd" > /tmp/cmd_output_$$ 2>&1 &
    local cmd_pid=$!

    start_spinner "$message" $cmd_pid

    wait $cmd_pid
    local exit_code=$?

    stop_spinner $exit_code "$success_msg"

    if [ $exit_code -ne 0 ] && [ ! -z "$error_msg" ]; then
        print_error "$error_msg"
        if [ -s /tmp/cmd_output_$$ ]; then
            echo -e "${COLOR_DIM}"
            tail -10 /tmp/cmd_output_$$ | sed 's/^/    /'
            echo -e "${COLOR_RESET}"
        fi
    fi

    rm -f /tmp/cmd_output_$$
    return $exit_code
}

# Box drawing
print_box() {
    local title="$1"
    local color="${2:-$COLOR_WHITE}"
    shift 2
    local lines=("$@")

    local max_len=${#title}
    for line in "${lines[@]}"; do
        local len=${#line}
        [ $len -gt $max_len ] && max_len=$len
    done

    local box_width=$((max_len + 4))

    echo -e "\n${color}╭─ ${COLOR_BOLD}${title}${COLOR_RESET}${color} $(printf '─%.0s' $(seq 1 $((box_width - ${#title} - 4))))╮${COLOR_RESET}"

    for line in "${lines[@]}"; do
        printf "${color}│${COLOR_RESET} %-${max_len}s ${color}│${COLOR_RESET}\n" "$line"
    done

    echo -e "${color}╰$(printf '─%.0s' $(seq 1 $box_width))╯${COLOR_RESET}\n"
}

# Summary table
print_table() {
    local -n headers=$1
    local -n rows=$2

    # Calculate column widths
    local -a widths=()
    for header in "${headers[@]}"; do
        widths+=(${#header})
    done

    for row in "${rows[@]}"; do
        IFS='|' read -ra cols <<< "$row"
        for i in "${!cols[@]}"; do
            local len=${#cols[$i]}
            [ $len -gt ${widths[$i]} ] && widths[$i]=$len
        done
    done

    # Print header
    echo -e "\n${COLOR_BOLD}"
    for i in "${!headers[@]}"; do
        printf "%-${widths[$i]}s  " "${headers[$i]}"
    done
    echo -e "${COLOR_RESET}"

    # Print separator
    echo -e "${COLOR_DIM}"
    for width in "${widths[@]}"; do
        printf '%*s' "$width" '' | tr ' ' '─'
        printf "  "
    done
    echo -e "${COLOR_RESET}"

    # Print rows
    for row in "${rows[@]}"; do
        IFS='|' read -ra cols <<< "$row"
        for i in "${!cols[@]}"; do
            printf "%-${widths[$i]}s  " "${cols[$i]}"
        done
        echo ""
    done
    echo ""
}

# Cleanup on exit
cleanup_ui() {
    if [ ! -z "$SPINNER_PID" ]; then
        kill $SPINNER_PID 2>/dev/null
        wait $SPINNER_PID 2>/dev/null
    fi
    tput cnorm # Show cursor
    echo -e "${COLOR_RESET}"
}

trap cleanup_ui EXIT INT TERM
