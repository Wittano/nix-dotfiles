# Packages
List of programs, that you can use in your configuration has the following convenction: 
```
- <pkg_name> - <link_to_source_or_description>
```
- pkgs_name - name of package, that you use in Nix e.g. 
```bash
nix run github:Wittano/nix-dotfiles#patcherDir
```
- link_to_source_or_description - link to source or program description

List of available packages:
- GTK themes
    - bibata-cursor-theme - [Bibata Cursor theme](https://github.com/ful1e5/Bibata_Cursor)
    - colloid-cursors-theme - https://github.com/vinceliuice/Colloid-icon-theme
- GTK icon themes
    - catppuccin-icon-theme - [Catppuccin icon theme](https://github.com/ljmill/catppuccin-icons)
- Plymouth themes
    - nixos-blur - [Nixos-Blur - theme for Plymouth](https://git.gurkan.in/gurkan/nixos-blur-plymouth)
- SDDM themes
    - dexy - [Dexy - SDDM theme](https://github.com/L4ki/Dexy-Plasma-Themes)
    - sugar-candy - [Sugar Candy - SDDM theme](https://framagit.org/MarianArlt/sddm-sugar-candy)
    - wings - [Wings - SDDM theme](https://github.com/L4ki/Wings-Plasma-Themes)
- Utilities
    - patcherDir - special script to patching binaries(changing default glibc path) for selected directory
- VIM plugins
    - gopher-nvim  [gopher.nvim plugin](https://github.com/olexsmir/gopher.nvim)
    - nvim-comment [nvim-comment plugin](https://github.com/terrortylor/nvim-comment)
    - plenary-nvim [plenary-nvim plugin](https://github.com/nvim-lua/plenary.nvim)
    - template-nvim [template.nvim plugin](https://github.com/nvimdev/template.nvim)
