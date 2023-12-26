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

      extraPlugins = with pkgs.vimPlugins; [ vim-wakatime ];

      globals.mapleader = " ";

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
            rust-analyzer = {
              enable = true;
              installRustc = true;
              installCargo = true;
            };
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
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "snippy"; }
            { name = "spell"; }
            { name = "buffer"; }
          ];
          snippet.expand = "luasnip";
          mappingPresets = [ "insert" ];
          mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<Tab>" = ''
              cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif snippy.can_expand_or_advance() then
                  snippy.expand_or_advance()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, {"i", "s"})
            '';
            "<S-Tab>" = ''
              function(fallback)
                if not cmp.select_prev_item() then
                  if vim.bo.buftype ~= 'prompt' and has_words_before() then
                    cmp.complete()
                  else
                    fallback()
                  end
                end
              end
            '';
          };
        };

        luasnip.enable = true;
        cmp-nvim-lua.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp-path.enable = true;
        cmp-snippy.enable = true;
        cmp-buffer.enable = true;
        cmp-spell.enable = true;
        cmp-vim-lsp.enable = true;

        lsp-format = {
          enable = true;
          lspServersToEnable = "all";
        };

        barbar = {
          enable = true;
          autoHide = true;
          insertAtEnd = true;
          keymaps = {
            close = "<leader>bd";
            goTo1 = "<leader>b1";
            goTo2 = "<leader>b2";
            goTo3 = "<leader>b3";
            goTo4 = "<leader>b4";
            goTo5 = "<leader>b5";
            goTo6 = "<leader>b6";
            goTo7 = "<leader>b7";
            goTo8 = "<leader>b8";
            goTo9 = "<leader>b9";
            next = "<leader>bj";
            previous = "<leader>bk";
          };
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
            "<leader>bf" = "buffers";
            "<C-p>" = "lsp_definitions";
          };
        };
      };
    };
  };
}
