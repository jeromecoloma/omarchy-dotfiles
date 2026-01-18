# Dotfiles

Personal dotfiles focused on modern CLI tooling, vim-style keybindings, and the Tokyo Night theme.

## Features

- **Modern CLI tools** - eza, bat, fzf, yazi replace traditional utilities
- **Vim keybindings** - Consistent vim-style navigation in shell and tmux
- **Tokyo Night theme** - Unified color scheme across terminal tools
- **Cross-platform clipboard** - Works with Wayland, X11, and tmux
- **Graceful fallbacks** - Configs work even when optional tools aren't installed

## What's Included

```
zsh/.zshrc      # Zsh shell configuration
tmux/.tmux.conf # Tmux terminal multiplexer configuration
```

## Prerequisites

### For Zsh

**Required:**
- [Zsh](https://www.zsh.org/)
- [Oh My Posh](https://ohmyposh.dev/) - Prompt theming

**Plugins:**
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)

### For Tmux

**Required:**
- [Tmux](https://github.com/tmux/tmux)
- [TPM](https://github.com/tmux-plugins/tpm) - Tmux Plugin Manager

### Recommended CLI Tools

These enhance both configs but aren't strictly required:
- [eza](https://github.com/eza-community/eza) - Modern `ls` replacement
- [bat](https://github.com/sharkdp/bat) - Syntax-highlighted file viewer
- [fzf](https://github.com/junegunn/fzf) - Fuzzy finder
- [yazi](https://github.com/sxyazi/yazi) - Terminal file manager
- [Neovim](https://neovim.io/) - Default editor

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/jeromecoloma/dotfiles.git ~/dotfiles
   ```

2. Symlink the configs you want to use:
   ```bash
   # Zsh
   ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc

   # Tmux
   ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
   ```

3. Additional setup per config:

   **For Zsh:**
   ```bash
   mkdir -p ~/.config/omp
   # Place your star.omp.json theme file in ~/.config/omp/
   source ~/.zshrc
   ```

   **For Tmux:**
   ```
   # Install TPM plugins (in tmux)
   prefix + I
   ```

## Key Configurations

### Zsh

| Feature | Description |
|---------|-------------|
| Vi mode | `Esc` to normal mode, cursor changes shape |
| `Ctrl+P` | Accept autosuggestion |
| `Ctrl+O` | Copy current command line to clipboard |
| `H` / `L` | Beginning/end of line (normal mode) |

**Aliases:**
- `ls` / `la` / `lt` - eza with icons and tree view
- `md` - bat for markdown/file viewing
- `y` - yazi file manager (returns to selected directory)
- `gs` / `gc` / `gco` - git shortcuts
- `tma` / `tmk` / `tml` - tmux session management

### Tmux

| Feature | Description |
|---------|-------------|
| `prefix + r` | Reload config |
| `prefix + I` | Install plugins |
| Vim navigation | hjkl pane navigation via vim-tmux-navigator |
| Copy mode | Vim keybindings |

**Plugins:**
- tmux-sensible - Sensible defaults
- vim-tmux-navigator - Seamless vim/tmux navigation
- tmux-resurrect - Session persistence
- tmux-yank - Clipboard integration
- tokyo-night-tmux - Theme

## Customization

### Secrets
Store private environment variables in `~/.zshrc.secrets` (gitignored):
```bash
export API_KEY="your-secret-key"
```

### NVM
If NVM is installed, the config auto-switches Node versions when entering directories with `.nvmrc` files.

### Theme
Modify the Oh My Posh theme at `~/.config/omp/star.omp.json`.

## Related

- [omarchy-setup](https://github.com/jeromecoloma/omarchy-setup) - Companion repository with setup scripts and additional configuration
