#!/bin/bash
# Enhanced Global Package Update Script with Beautiful UI
# Usage: ./update.sh

# Source the UI library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/ui-lib.sh"

# Statistics tracking
STATS_TOTAL=0
STATS_SUCCESS=0
STATS_FAILED=0
STATS_SKIPPED=0
START_TIME=$(date +%s)

# Update function
update() {
    clear
    print_header "🚀 Global Package Update Manager"

    echo -e "${COLOR_CYAN}Starting comprehensive package update process...${COLOR_RESET}"
    echo -e "${COLOR_DIM}Started at: $(date '+%Y-%m-%d %H:%M:%S')${COLOR_RESET}\n"

    # NPM Updates
    print_section "$SYMBOL_PACKAGE" "NPM Package Manager"

    if command -v npm &> /dev/null; then
        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Updating NPM to latest version" \
            "NPM updated successfully" \
            "Failed to update NPM" \
            "npm install -g npm@latest"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))

        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Updating global NPM packages" \
            "Global packages updated" \
            "Failed to update global packages" \
            "npm update -g"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))

        # Check for deprecated packages
        print_step "Checking for deprecated packages..."
        if npm list -g uuid@3 2>/dev/null | grep -q "uuid@"; then
            STATS_TOTAL=$((STATS_TOTAL + 1))
            execute_with_feedback \
                "Updating deprecated uuid package" \
                "UUID package updated" \
                "Failed to update UUID" \
                "npm install -g uuid@latest"
            [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))
        else
            print_info "No deprecated uuid package found"
        fi

        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Cleaning NPM cache" \
            "Cache cleaned successfully" \
            "Failed to clean cache" \
            "npm cache clean --force"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))
    else
        print_warning "NPM not found, skipping NPM updates"
        STATS_SKIPPED=$((STATS_SKIPPED + 1))
    fi

    # Bun Updates
    print_section "$SYMBOL_FIRE" "Bun Package Manager"

    if command -v bun &> /dev/null; then
        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Updating global Bun packages" \
            "Bun packages updated" \
            "Failed to update Bun packages" \
            "bun update --global"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))
    else
        print_warning "Bun not found, skipping Bun updates"
        STATS_SKIPPED=$((STATS_SKIPPED + 1))
    fi

    # Homebrew Updates
    print_section "$SYMBOL_BEER" "Homebrew Package Manager"

    if command -v brew &> /dev/null; then
        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Updating Homebrew" \
            "Homebrew updated" \
            "Failed to update Homebrew" \
            "brew update"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))

        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Upgrading Homebrew packages" \
            "Packages upgraded" \
            "Failed to upgrade packages" \
            "brew upgrade"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))

        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Upgrading Homebrew casks" \
            "Casks upgraded" \
            "Failed to upgrade casks" \
            "brew upgrade --cask"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))

        STATS_TOTAL=$((STATS_TOTAL + 1))
        execute_with_feedback \
            "Cleaning up Homebrew" \
            "Cleanup completed" \
            "Failed to cleanup" \
            "brew cleanup"
        [ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))
    else
        print_warning "Homebrew not found, skipping Brew updates"
        STATS_SKIPPED=$((STATS_SKIPPED + 1))
    fi

    # Show outdated packages
    print_section "$SYMBOL_CLIPBOARD" "Package Status Report"

    if command -v npm &> /dev/null; then
        print_step "Checking for outdated global NPM packages..."
        echo ""

        local outdated_output=$(npm outdated -g --depth=0 2>/dev/null)
        if [ -z "$outdated_output" ]; then
            print_success "All global NPM packages are up to date!"
        else
            echo -e "${COLOR_DIM}$outdated_output${COLOR_RESET}"
        fi
    fi

    # Summary
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))

    print_header "📊 Update Summary"

    local summary_lines=(
        "Total Operations:    $STATS_TOTAL"
        "Successful:          ${COLOR_GREEN}$STATS_SUCCESS${COLOR_RESET}"
        "Failed:              ${COLOR_RED}$STATS_FAILED${COLOR_RESET}"
        "Skipped:             ${COLOR_YELLOW}$STATS_SKIPPED${COLOR_RESET}"
        ""
        "Time Elapsed:        ${DURATION}s"
        "Completed:           $(date '+%Y-%m-%d %H:%M:%S')"
    )

    print_box "Results" "$COLOR_CYAN" "${summary_lines[@]}"

    if [ $STATS_FAILED -eq 0 ]; then
        echo -e "${COLOR_GREEN}${COLOR_BOLD}${SYMBOL_CHECK} All updates completed successfully!${COLOR_RESET}\n"
    else
        echo -e "${COLOR_YELLOW}${COLOR_BOLD}${SYMBOL_WARN} Updates completed with $STATS_FAILED failure(s)${COLOR_RESET}\n"
    fi
}

# Run the update
update
