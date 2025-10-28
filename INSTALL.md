# Beautiful Bash UI System

A comprehensive visual UI library for creating stunning command-line interfaces in bash scripts.

## 📦 Installation

### Quick Setup

1. **Download the files:**
```bash
# Create a directory for your scripts
mkdir -p ~/scripts
cd ~/scripts

# Save the three files:
# - ui-lib.sh (the core library)
# - update.sh (your enhanced update script)
# - example-usage.sh (examples and demos)
```

2. **Make scripts executable:**
```bash
chmod +x update.sh example-usage.sh
```

3. **Run the update script:**
```bash
./update.sh
```

## 🎨 Features

### Visual Components

- ✅ **Headers & Sections** - Beautiful bordered headers and section dividers
- 🎯 **Status Messages** - Success, error, warning, info, and step indicators
- ⚡ **Spinners** - Animated loading spinners with custom messages
- 📊 **Progress Bars** - Visual progress tracking
- 📦 **Boxes** - Bordered content containers
- 📋 **Tables** - Clean formatted tables
- 🎨 **Colors** - Full color palette with bold and dim variants

### Command Execution

- **execute_with_feedback** - Run commands with spinner and automatic status reporting
- Captures output for error display
- Returns exit codes for conditional logic

## 🚀 Usage

### Basic Usage in Your Scripts

```bash
#!/bin/bash
source "path/to/ui-lib.sh"

# Print a header
print_header "My Awesome Script"

# Show a section
print_section "📦" "Installing Packages"

# Execute with visual feedback
execute_with_feedback \
    "Installing dependencies" \
    "Dependencies installed" \
    "Installation failed" \
    "npm install"

# Show status messages
print_success "Operation completed"
print_error "Something went wrong"
print_warning "Be careful!"
print_info "Here's some info"
```

### Progress Bars

```bash
total=100
for i in $(seq 1 $total); do
    show_progress $i $total "Processing..."
    # Do work here
done
```

### Tables

```bash
headers=("Name" "Version" "Status")
rows=(
    "react|18.2.0|✓ Updated"
    "vue|3.3.4|⚠ Pending"
)

print_table headers rows
```

### Boxes

```bash
lines=(
    "Configuration loaded"
    "Server: localhost:3000"
    "Mode: production"
)

print_box "Settings" "$COLOR_GREEN" "${lines[@]}"
```

## 📝 Available Functions

### Print Functions
- `print_header "text"` - Large bordered header
- `print_section "icon" "text"` - Section with icon and divider
- `print_success "text"` - Green success message
- `print_error "text"` - Red error message
- `print_warning "text"` - Yellow warning message
- `print_info "text"` - Cyan info message
- `print_step "text"` - Dimmed step indicator

### Execution Functions
- `execute_with_feedback "loading_msg" "success_msg" "error_msg" "command"` - Run command with spinner
- `start_spinner "message" pid` - Start animated spinner
- `stop_spinner exit_code "message"` - Stop spinner and show result

### Visual Elements
- `show_progress current total "label"` - Display progress bar
- `print_box "title" "color" "line1" "line2" ...` - Draw bordered box
- `print_table header_array row_array` - Display formatted table

## 🎨 Colors & Symbols

### Available Colors
```bash
COLOR_RED, COLOR_GREEN, COLOR_YELLOW, COLOR_BLUE
COLOR_MAGENTA, COLOR_CYAN, COLOR_WHITE
COLOR_BOLD, COLOR_DIM, COLOR_RESET
```

### Unicode Symbols
```bash
SYMBOL_CHECK="✓"    SYMBOL_CROSS="✗"
SYMBOL_INFO="ℹ"     SYMBOL_WARN="⚠"
SYMBOL_ARROW="→"    SYMBOL_BULLET="•"
SYMBOL_STAR="★"     SYMBOL_ROCKET="🚀"
SYMBOL_PACKAGE="📦" SYMBOL_FIRE="⚡"
```

## 🔧 Customization

### Creating Your Own Functions

```bash
my_custom_task() {
    print_section "$SYMBOL_WRENCH" "Custom Task"

    execute_with_feedback \
        "Running custom operation" \
        "Custom operation succeeded" \
        "Custom operation failed" \
        "your-command-here"

    if [ $? -eq 0 ]; then
        print_success "Task completed successfully"
    else
        print_error "Task failed"
        return 1
    fi
}
```

### Adding Statistics Tracking

```bash
STATS_SUCCESS=0
STATS_FAILED=0

# After each operation:
[ $? -eq 0 ] && STATS_SUCCESS=$((STATS_SUCCESS + 1)) || STATS_FAILED=$((STATS_FAILED + 1))

# Display summary:
print_box "Results" "$COLOR_CYAN" \
    "Successful: $STATS_SUCCESS" \
    "Failed: $STATS_FAILED"
```

## 💡 Tips

1. **Source the library** at the start of every script
2. **Use descriptive messages** for better UX
3. **Wrap long operations** in `execute_with_feedback` for visual feedback
4. **Clear the screen** before major operations for clean output
5. **Add sections** to group related operations
6. **Track statistics** for summary reports

## 🐛 Troubleshooting

**Spinner not showing:**
- Ensure your terminal supports Unicode
- Check that `tput` is available

**Colors not working:**
- Verify terminal supports ANSI colors
- Some terminals may need `export TERM=xterm-256color`

**Function not found:**
- Make sure you `source ui-lib.sh` before using functions
- Check the path to ui-lib.sh is correct

## 📚 Examples

Run the example script to see all components in action:

```bash
./example-usage.sh
```

## 🎯 Best Practices

1. **Always cleanup** - The library handles this automatically via trap
2. **Handle errors** - Check exit codes after operations
3. **Provide feedback** - Use spinners for long operations
4. **Group logically** - Use sections to organize output
5. **Keep it simple** - Don't over-use colors and symbols

---

**Need help?** Check `example-usage.sh` for comprehensive examples of every feature.
