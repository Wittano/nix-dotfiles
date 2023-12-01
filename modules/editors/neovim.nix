{ config, pkgs, lib, home-manager, dotfiles, ... }:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.modules.editors.neovim;
in
{
  options = {
    modules.editors.neovim = {
      enable = mkEnableOption ''
        Enable Neovim editor
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;

      globals = {
        mapleader = " ";
      };

      options = {
        number = true;
        relativenumber = true;
        swapfile = false;
        wrap = true;
        smartindent = true;
        tabstop = 4;
        softtabstop = 4;
        shiftwidth = 4;
        expandtab = true;

        hlsearch = true;
        incsearch = true;
      };

      colorschemes.catppuccin =
        let
          theme = "macchiato";
        in
        {
          enable = true;
          background = {
            dark = theme;
            light = theme;
          };
          flavour = theme;
        };

      plugins = {
        packer = {
          enable = true;
          plugins = [
            "wakatime/vim-wakatime"
          ];
        };

        undotree = {
          autoOpenDiff = true;
          focusOnToggle = true;
          enable = true;
        };

        lsp = {
          enable = true;
          capabilities = "require('cmp_nvim_lsp').default_capabilities()";
          keymaps = {
            diagnostic = {
              "<leader>j" = "goto_next";
              "<leader>k" = "goto_prev";
            };
            lspBuf = {
              K = "hover";
              gD = "references";
              gd = "definition";
              gi = "implementation";
              gt = "type_definition";
            };
          };
          servers = {
            rnix-lsp.enable = true;
            rust-analyzer.enable = true;
            tsserver.enable = true;
            yamlls.enable = true;
            pylsp = {
              enable = true;
              settings.plugins = {
                rope.enabled = true;
                pylsp_mypy.enabled = true;
                pylint.enabled = true;
                isort.enabled = true;
                flake8.enabled = true;
                black.enabled = true;
              };
            };
            html.enable = true;
            gopls.enable = true;
            eslint.enable = true;
            cssls.enable = true;
            clangd.enable = true;
            bashls.enable = true;
          };
        };

        nvim-cmp = {
          enable = true;
          snippet.expand = "snippy";
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "snippy"; }
            { name = "cmdline"; }
            { name = "buffer"; }
          ];
          mappingPresets = [ "insert" ];
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };

        cmp-nvim-lua.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-path.enable = true;
        cmp-snippy.enable = true;
        cmp-cmdline.enable = true;
        cmp-buffer.enable = true;
        cmp-vim-lsp.enable = true;

        lsp-format = {
          enable = true;
          lspServersToEnable = "all";
        };

        lightline = {
          enable = true;
          colorscheme = "catppuccin";
        };

        nix.enable = true;

        surround.enable = true;
        todo-comments.enable = true;
        fugitive.enable = true;

        telescope = {
          enable = true;
          keymaps = {
            "<leader>ff" = "find_files";
            "<leader>fg" = "git_files";
            "<leader>gg" = "live_grep";
            "<C-p>" = "lsp_definitions";
          };
        };
      };
    };
  };
}
