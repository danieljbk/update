# Terminal Integration Setup

Complete guide to make your `update` command available globally in your terminal.

## 🎯 Recommended Setup Method

## Option 1: Alias (Simplest)

The quickest method, but less flexible:

```bash
# Add to ~/.bashrc
alias update='~/.local/bin/scripts/update.sh'
```

Then:
```bash
source ~/.bashrc
update
```

---

## Option 2: Symlink to PATH (Alternative)

If you prefer to keep the script as a standalone file:

1. **Ensure update.sh is executable:**
```bash
chmod +x ~/.local/bin/scripts/update.sh
```

2. **Add ~/.local/bin to PATH (if not already):**
```bash
# Add to ~/.bashrc
export PATH="$HOME/.local/bin:$PATH"
```

3. **Create symlink:**
```bash
ln -s ~/.local/bin/scripts/update.sh ~/.local/bin/update
```

4. **Reload and test:**
```bash
source ~/.bashrc
update
```

---

### Option 3: Function in .bashrc (Cleanest)

This is the cleanest approach - it sources the library and defines the function in your shell environment.

1. **Create a scripts directory (if you haven't already):**
```bash
mkdir -p ~/.local/bin/scripts
```

2. **Move your files there:**
```bash
mv ui-lib.sh ~/.local/bin/scripts/
mv update.sh ~/.local/bin/scripts/
```

3. **Add to your `~/.bashrc` (or `~/.zshrc` if using zsh):**
```bash
# Add this at the end of your .bashrc file
nano ~/.bashrc
```

Add these lines:
```bash
# Custom update function with beautiful UI
if [ -f "$HOME/.local/bin/scripts/ui-lib.sh" ]; then
    source "$HOME/.local/bin/scripts/ui-lib.sh"

    update() {
        local SCRIPT_DIR="$HOME/.local/bin/scripts"

        # Statistics tracking
        STATS_TOTAL=0
        STATS_SUCCESS=0
        STATS_FAILED=0
        STATS_SKIPPED=0
        START_TIME=$(date +%s)

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
fi
```

4. **Reload your shell:**
```bash
source ~/.bashrc
```

5. **Test it:**
```bash
update
```

---

## 🔧 For Zsh Users

If you're using Zsh instead of Bash:

1. Edit `~/.zshrc` instead of `~/.bashrc`
2. Everything else remains the same
3. Reload with: `source ~/.zshrc`

---

## ✅ Verification

After setup, verify everything works:

```bash
# Check if update command is available
type update

# Should output something like:
# update is a function
# update is /home/user/.local/bin/update
# or
# update is aliased to '~/.local/bin/scripts/update.sh'

# Run the update
update
```

---

## 🎨 Adding More Custom Commands

Once you have this setup, you can easily add more functions:

```bash
# In your .bashrc, after sourcing ui-lib.sh:

my_backup() {
    print_header "💾 Backup Manager"
    # Your backup logic here
}

my_cleanup() {
    print_header "🧹 System Cleanup"
    # Your cleanup logic here
}
```

---

## 🐛 Troubleshooting

**Command not found after setup:**
```bash
# Make sure you reloaded your shell
source ~/.bashrc

# Or open a new terminal window
```

**Function not defined:**
```bash
# Check if ui-lib.sh exists
ls -la ~/.local/bin/scripts/ui-lib.sh

# Check if .bashrc has the code
tail -50 ~/.bashrc
```

**Permission denied:**
```bash
# Ensure files are executable
chmod +x ~/.local/bin/scripts/ui-lib.sh
chmod +x ~/.local/bin/scripts/update.sh
```

---

## 📝 Recommended: Option 1

**Option 1 (function in .bashrc)** is recommended because:
- ✅ Cleanest integration
- ✅ Fastest execution (no script spawn)
- ✅ Easy to modify
- ✅ Works everywhere your .bashrc is sourced
- ✅ Can use shell variables and functions directly

Choose Option 2 or 3 if you prefer keeping the script separate from your .bashrc file.
