#!/bin/bash
# Example Usage of UI Library
# This demonstrates all available UI components

source "$(dirname "$0")/ui-lib.sh"

clear

# Header Example
print_header "🎨 UI Library Demo - All Components"

# Section with different icons
print_section "$SYMBOL_ROCKET" "Basic Print Functions"

print_success "This is a success message"
print_error "This is an error message"
print_warning "This is a warning message"
print_info "This is an info message"
print_step "This is a step indicator"

# Box Example
print_section "$SYMBOL_STAR" "Box Drawing"

box_lines=(
    "First line of content"
    "Second line with more text"
    "Third line: Value = 42"
)
print_box "Configuration" "$COLOR_GREEN" "${box_lines[@]}"

# Progress Bar Example
print_section "$SYMBOL_FIRE" "Progress Bar"

echo ""
for i in {1..10}; do
    show_progress $i 10 "Processing items..."
    sleep 0.2
done

# Execute with Feedback Example
print_section "$SYMBOL_WRENCH" "Command Execution"

execute_with_feedback \
    "Running test command" \
    "Command completed successfully" \
    "Command failed" \
    "sleep 2 && echo 'Test complete'"

# Table Example
print_section "$SYMBOL_CLIPBOARD" "Table Display"

table_headers=("Package" "Version" "Status")
table_rows=(
    "react|18.2.0|✓ Updated"
    "vue|3.3.4|✓ Updated"
    "svelte|4.0.5|⚠ Outdated"
)

print_table table_headers table_rows

# Multi-step process example
print_section "$SYMBOL_PACKAGE" "Multi-Step Process Demo"

steps=("Initialize" "Download" "Install" "Configure" "Cleanup")
total=${#steps[@]}

for i in "${!steps[@]}"; do
    current=$((i + 1))
    print_step "${steps[$i]}..."
    sleep 0.5
    print_success "${steps[$i]} completed"
done

# Final Summary
print_header "✨ Demo Complete"

echo -e "${COLOR_CYAN}All UI components demonstrated successfully!${COLOR_RESET}\n"
echo -e "${COLOR_DIM}Use these functions in your own scripts for beautiful output.${COLOR_RESET}\n"
