{ config, pkgs, lib, home-manager, dotfiles, inputs, privateRepo, ... }:
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

  config = mkIf cfg.enable {
    modules.shell.fish.completions = [{
      name = "tvi";
      value = ''complete -c tvi -x -a "(__fish_complete_directories)"'';
    }];

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

    programs.nixvim =
      let
        nixvimLib = inputs.nixvim.lib.x86_64-linux;
        plugins = builtins.map
          (x: pkgs.callPackage ./plugins/${x} { inherit privateRepo; })
          (builtins.attrNames
            (attrsets.filterAttrs
              (n: _: strings.hasSuffix ".nix" n)
              (builtins.readDir ./plugins)));
        customPlugins = lists.flatten (builtins.map (x: x.deps) plugins);
        luaConfigs = builtins.concatStringsSep "\n\n" (builtins.map (x: x.luaConfig) plugins);
      in
      {
        enable = true;
        enableMan = true;
        viAlias = true;

        extraPlugins = with pkgs.vimPlugins; [ vim-wakatime vimsence ] ++ customPlugins;

        extraConfigLua = /*lua*/
          ''
            -- nvim-autopairs
            require("nvim-autopairs").setup()

            ${luaConfigs}
          '';

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

        colorschemes = {
          catppuccin =
            let theme = "macchiato";
            in
            {
              enable = true;
              terminalColors = true;
              background = {
                dark = theme;
                light = theme;
              };
              styles = {
                comments = [ "italic" ];
                functions = [ "italic" ];
              };
              flavour = theme;
              integrations = {
                native_lsp.enabled = true;
                telescope.enabled = true;
                dap = {
                  enable_ui = true;
                  enabled = true;
                };
              };
            };
        };

        plugins = {
          treesitter.enable = true;

          undotree = {
            autoOpenDiff = true;
            focusOnToggle = true;
            enable = true;
          };

          dap = {
            enable = true;
            extensions = {
              dap-go = {
                enable = true;
                dapConfigurations = [{
                  name = "Debug with Arguments from DEBUG_ARGS env";
                  request = "launch";
                  type = "go";
                  program = "\${file}";
                  args = nixvimLib.helpers.mkRaw # lua
                    ''
                      function()
                        return coroutine.create(function(dap_run_co)
                          local args = vim.split(os.getenv("DEBUG_ARGS") or "", " ")
                          coroutine.resume(dap_run_co, args)
                        end)
                      end
                    '';
                }];
                delve.path = "${pkgs.delve}/bin/dlv";
              };
              dap-python = {
                enable = true;
                adapterPythonPath = "${pkgs.python3}/bin/python";
              };
              dap-ui.enable = true;
              dap-virtual-text.enable = true;
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
              lua-ls.enable = true;
              html.enable = true;
              gopls = {
                enable = true;
                onAttach.function = # lua
                  ''
                    vim.api.nvim_create_autocmd("BufWritePre", {
                      pattern = "*.go",
                      callback = function()
                        local params = vim.lsp.util.make_range_params()
                        params.context = {only = {"source.organizeImports"}}
                        -- buf_request_sync defaults to a 1000ms timeout. Depending on your
                        -- machine and codebase, you may want longer. Add an additional
                        -- argument after params if you find that you have to write the file
                        -- twice for changes to be saved.
                        -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
                        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
                        for cid, res in pairs(result or {}) do
                          for _, r in pairs(res.result or {}) do
                            if r.edit then
                              local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                              vim.lsp.util.apply_workspace_edit(r.edit, enc)
                            end
                          end
                        end
                        vim.lsp.buf.format({async = false})
                      end
                    })
                  '';
              };
              cmake.enable = true;
              gdscript.enable = true;
              eslint.enable = true;
              cssls.enable = true;
              clangd.enable = true;
              bashls.enable = true;
              jsonls.enable = true;
              tailwindcss.enable = true;
              taplo.enable = true;
              terraformls.enable = true;
              nixd.enable = true;

              #graphql.enable = true;
              #dockerls.enable = true;
              #ansiblels.enable = true;
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

          efmls-configs = {
            enable = true;
            setup.go.formatter = [ "goimports" ];
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

          tmux-navigator.enable = true;

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
            extensions.file_browser = {
              enable = true;
              hidden = true;
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
            disableInReplaceMode = true;
          };
        };

        keymaps = [
          # Custom
          {
            action = "<cmd> Explore<CR>";
            key = "<leader>fe";
          }
          {
            action = # lua
              ''
                function()
                  local newFileName = vim.fn.input("Enter new file name: ", "", "dir")
                  local newFilePath = os.getenv("PWD") .. '/' .. newFileName

                  if newFilePath:sub(-string.len(newFilePath)) == "/" then
                    vim.fn.mkdir(vim.fs.dirname(newFilePath), 'p')
                    return
                  end

                  vim.cmd('edit ' .. newFilePath)
                  vim.cmd("Telescope find_template type=insert filter_ft=true")
                end
              '';
            key = "<leader>fc";
            lua = true;
          }
          {
            action = # lua
              ''
                function()
                  local newDirectoryName = vim.fn.input("Enter new directory name: ", "", "dir")
                  local newDirectoryPath = os.getenv("PWD") .. '/' .. newDirectoryName

                  vim.fn.mkdir(newDirectoryPath, 'p')
                  print("Created new directory: " .. newDirectoryPath)
                end
              '';
            key = "<leader>fd";
            lua = true;
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
          # DAP
          {
            action = ''function() require("dapui").toggle() end'';
            lua = true;
            key = "<F9>";
          }
          {
            action = "<cmd> DapToggleBreakpoint<CR>";
            key = "<F8>";
          }
          {
            action = "<cmd> DapContinue<CR>";
            key = "<F10>";
          }
          # Golang
          {
            action = "<cmd> GoIfErr<CR>";
            key = "<A-e>";
          }
          {
            action = "<cmd> GoImpl<CR>";
            key = "<A-i>";
          }
        ];
      };
  };
}
