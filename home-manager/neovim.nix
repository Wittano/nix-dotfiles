{ config, pkgs, lib, ... }:
with lib;
{
  options.programs.neovim.wittano.enable = mkEnableOption "Enable Neovim editor";

  config = mkIf config.programs.neovim.wittano.enable {
    home.packages = with pkgs; [ ripgrep ];

    programs = {
      fish = {
        wittano.completions."tvi" = ''complete -c tvi -x -a "(__fish_complete_directories)"'';
        functions.tvi.body = /*fish*/ ''
          if test -d $argv
            cd $argv 
          end

          tmux new-session -d "nvim"
          tmux new-window
          tmux attach-session
        '';
      };

      nixvim = {
        enable = true;
        enableMan = true;
        viAlias = true;

        extraPlugins = with pkgs.vimPlugins; [ vimsence nvim-comment nvim-treesitter-parsers.haskell ];

        extraConfigLua = /*lua*/
          ''
            -- nvim-autopairs
            require("nvim-autopairs").setup()
            require('nvim_comment').setup()
          '';

        globals.mapleader = " ";

        opts = {
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

        colorschemes.catppuccin = {
          enable = true;
          settings = rec {
            term_colors = true;
            background = {
              dark = flavour;
              light = flavour;
            };
            styles = {
              comments = [ "italic" ];
              functions = [ "italic" ];
            };
            flavour = config.catppuccin.flavor;
            integrations = {
              native_lsp.enabled = true;
              telescope.enabled = true;
            };
          };
        };

        plugins = {
          nvim-tree = {
            enable = true;
            autoClose = true;
            autoReloadOnWrite = true;
            actions = {
              useSystemClipboard = true;
              openFile = {
                quitOnOpen = true;
                resizeWindow = true;
              };
              windowPicker.enable = true;
            };
            git = {
              enable = true;
              ignore = false;
            };
            liveFilter.alwaysShowFolders = true;
            updateFocusedFile.enable = true;
            view = {
              number = true;
              relativenumber = true;
            };
          };

          undotree = {
            enable = true;
            settings = {
              AutoOpenDiff = true;
              FocusOnToggle = true;
            };
          };

          lsp = {
            enable = true;
            capabilities = # lua
              "require('cmp_nvim_lsp').default_capabilities()";
            keymaps = {
              diagnostic = {
                "<leader>j" = "goto_next";
                "<leader>k" = "goto_prev";
                "<leader>q" = "open_float";
              };
              lspBuf = {
                K = "hover";
                gD = "references";
                gd = "definition";
                gi = "implementation";
                gt = "type_definition";
                R = "rename";
              };
            };
            servers = rec {
              html = {
                enable = true;
                filetypes = [ "html" "heex" "jsx" "tsx" ];
              };
              htmx = {
                inherit (html) filetypes;

                enable = true;
              };
              tailwindcss = {
                enable = true;
                filetypes = html.filetypes ++ [ "css" ];
              };
              elixirls.enable = true;
              bashls = {
                enable = true;
                package = pkgs.nodePackages.bash-language-server;
              };
              terraformls.enable = true;
              nil_ls = {
                enable = true; # Nix
                settings.formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
              };
              hls = {
                enable = true;
                installGhc = true;
                filetypes = [ "haskell" "lhaskell" "cabal" ];
                package = pkgs.haskell-language-server;
              };
              dockerls.enable = true;
              ansiblels.enable = true;
            };
          };

          web-devicons.enable = true;
          treesitter = {
            enable = true;
            settings.highlight.enable = true;
          };

          luasnip.enable = true;
          cmp-nvim-lua.enable = true;
          cmp-nvim-lsp.enable = true;
          cmp-path.enable = true;
          cmp-buffer.enable = true;
          cmp-spell.enable = true;
          cmp-vim-lsp.enable = true;
          cmp = {
            enable = true;
            settings = {
              sources = [
                { name = "nvim_lsp"; }
                { name = "path"; }
                { name = "spell"; }
                { name = "buffer"; }
                { name = "vim_lsp"; }
                { name = "nvim_lua"; }
              ];
              snippet.expand = ''
                function(args)
                  require('luasnip').lsp_expand(args.body)
                end
              '';
              mapping.__raw = ''
                cmp.mapping.preset.insert({
                  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                  ['<C-f>'] = cmp.mapping.scroll_docs(4),
                  ['<C-Space>'] = cmp.mapping.complete(),
                  ['<C-e>'] = cmp.mapping.abort(),
                  ['<CR>'] = cmp.mapping.confirm({ select = true }),
                })
              '';
            };
          };

          lsp-format = {
            enable = true;
            lspServersToEnable = "all";
          };

          nix.enable = true;

          tmux-navigator.enable = true;

          lightline = {
            enable = true;
            settings.colorscheme = "catppuccin";
          };

          vim-surround.enable = true;
          todo-comments.enable = true;
          fugitive.enable = true;

          telescope = {
            enable = true;
            extensions.file-browser = {
              enable = true;
              settings.hidden = true;
            };
            keymaps = {
              "<leader>ff" = "find_files";
              "<leader>fg" = "git_files";
              "<leader>gg" = "live_grep";
              "<leader>bb" = "buffers";
              "<C-p>" = "lsp_definitions";
            };
          };

          endwise.enable = true;
          gitblame.enable = true;

          nvim-autopairs = {
            enable = true;
            settings.disable_in_replace_mode = true;
          };
        };

        keymaps = [
          # TmuxNavigate
          {
            action = "<cmd> TmuxNavifateLeft<CR>";
            key = "<C-h>";
          }
          {
            action = "<cmd> TmuxNavifateRight<CR>";
            key = "<C-l>";
          }
          {
            action = "<cmd> TmuxNavifateDown<CR>";
            key = "<C-j>";
          }
          {
            action = "<cmd> TmuxNavifateUp<CR>";
            key = "<C-k>";
          }
          # Undotree
          {
            action = "<cmd> UndotreeToggle<CR>";
            key = "U";
          }
          # nvim-tree.lua
          {
            action = "<cmd> NvimTreeToggle<CR>";
            key = "<leader>te";
          }
        ];
      };
    };
  };
}
