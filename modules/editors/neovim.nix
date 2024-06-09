{ config, pkgs, lib, inputs, ... }:
with lib;
with lib.my;
let
  cfg = config.modules.editors.neovim;
in
{
  options = {
    modules.editors.neovim = {
      enable = mkEnableOption "Enable Neovim editor";
    };
  };

  imports = [
    inputs.nixvim.nixosModules.nixvim
  ];

  config = mkIf cfg.enable {
    modules.shell.fish.completions."tvi" = ''complete -c tvi -x -a "(__fish_complete_directories)"'';

    home-manager.users.wittano = {
      home.packages = with pkgs; [ ripgrep ];
      programs.fish.functions.tvi.body = /*fish*/ ''
        if test -d $argv
          cd $argv
        end

        tmux new-session -d "nvim"
        tmux new-window
        tmux attach-session
      '';
    };

    programs.nixvim = {
      enable = true;
      enableMan = true;
      viAlias = true;

      extraPlugins = with pkgs.vimPlugins; [ vim-wakatime vimsence nvim-comment ];

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
          flavour = "macchiato";
          integrations = {
            native_lsp.enabled = true;
            telescope.enabled = true;
          };
        };
      };

      plugins = {
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
          servers = {
            yamlls.enable = true;
            bashls.enable = true;
            jsonls.enable = true;
            taplo.enable = true;
          };
        };

        cmp-path.enable = true;
        cmp-spell.enable = true;
        cmp-buffer.enable = true;
        cmp-nvim-lsp.enable = true;

        cmp = {
          enable = true;
          settings.sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "spell"; }
            { name = "buffer"; }
          ];
          cmdline.mapping = {
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.abort()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };

        tmux-navigator.enable = true;

        lightline = {
          enable = true;
          colorscheme = "catppuccin";
        };

        surround.enable = true;
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
            "<leader>bf" = "buffers";
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
        # Custom
        {
          action = "<cmd> Explore<CR>";
          key = "<leader>fe";
        }
        {
          action.__raw = # lua
            ''
              function()
                local newFileName = vim.fn.input("Enter new file name: ", "", "dir")
                local newFilePath = os.getenv("PWD") .. '/' .. newFileName

                if newFilePath:sub(-string.len(newFilePath)) == "/" then
                  vim.fn.mkdir(vim.fs.dirname(newFilePath), 'p')
                  return
                end

                vim.cmd('edit ' .. newFilePath)
              end
            '';
          key = "<leader>fc";
        }
        {
          action.__raw = # lua
            ''
              function()
                local newDirectoryName = vim.fn.input("Enter new directory name: ", "", "dir")
                local newDirectoryPath = os.getenv("PWD") .. '/' .. newDirectoryName

                vim.fn.mkdir(newDirectoryPath, 'p')
                print("Created new directory: " .. newDirectoryPath)
              end
            '';
          key = "<leader>fd";
        }
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
      ];
    };
  };
}
