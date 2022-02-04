call plug#begin('~/.local/share/nvim/plugged')

  " Auto Complete
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " GoLang
  Plug 'https://github.com/jansenm/vim-cmake.git' " Cmake
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  "Theme
  Plug 'vim-airline/vim-airline-themes'
  Plug 'jschmold/sweet-dark.vim'

  "Formater
  Plug 'bronson/vim-trailing-whitespace' "Remove unnecesarry spaces and whitespace
  Plug 'airblade/vim-gitgutter' "Show changes in repo

  "Syntax
  Plug 'https://github.com/PotatoesMaster/i3-vim-syntax.git' "Vim i3 syntax
  Plug 'https://github.com/octol/vim-cpp-enhanced-highlight.git' "Cpp syntax
  Plug 'https://github.com/pboettch/vim-cmake-syntax.git' " CMake syntax
  Plug 'sheerun/vim-polyglot' " Syntax for so much language
  Plug 'dense-analysis/ale' " ALE
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  Plug 'LnL7/vim-nix' " Vim-nix

  "Lightline
  Plug 'itchyny/lightline.vim' "Light line
  Plug 'https://github.com/itchyny/vim-gitbranch.git' "Show currently git branch on Light line

  "Facilitate
  Plug 'https://github.com/jlanzarotta/bufexplorer.git'
  Plug 'jiangmiao/auto-pairs' " Added missing bracket
  Plug 'https://github.com/tpope/vim-fugitive.git'
  Plug 'https://github.com/tpope/vim-commentary.git' "Auto commentary
  Plug 'https://github.com/tpope/vim-surround.git' "Click link and you know what is it
  Plug 'https://github.com/tpope/vim-repeat.git' "Repeat last action if you click '.'
  Plug 'reedes/vim-pencil' "Facilitate read text
  Plug 'terryma/vim-multiple-cursors' " Modified code in few lines at same time
  Plug 'https://github.com/Shougo/echodoc.vim.git' " Show parms in function

call plug#end()

syntax on
syntax enable

set background=dark
set autoindent
set smarttab
set tabstop=4
set shiftwidth=4
set smartcase
set nu rnu
set clipboard+=unnamedplus
filetype on
filetype plugin indent on
set encoding=UTF-8
set cmdheight=2
set nobackup
set nowritebackup
set shortmess+=c
set signcolumn=yes

" Auto start command
autocmd FileType python set sw=4
autocmd FileType python set ts=4
autocmd FileType python set sts=4
autocmd FileType apache setlocal commentstring=#\ %s
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags

set termguicolors     " enable true colors support
" Theme
colorscheme sweet_dark

" Always show lightline
set laststatus=2
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             ['readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'filetype' ],
      \              [ 'gitbranch'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

nnoremap <silent>,<space> :nohlsearch<CR>
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Custom keybinds
map tt :NERDTreeToggle<CR>
map tc :NERDTreeClose<CR>
map tf :NERDTreeFocus<CR>
map <F2> :CocCommand document.renameCurrentWord<CR>

nmap <silent> <A-k> :wincmd k<CR>
nmap <silent> <A-j> :wincmd j<CR>
nmap <silent> <A-h> :wincmd h<CR>
nmap <silent> <A-l> :wincmd l<CR>

"Tab managment
map <C-o> :tabnew<CR>
map <C-c> :tabclose<CR>
map <C-l> :tabn<CR>
map <C-h> :tabp<CR>

" Go keymaps
autocmd FileType go map <F2> :GoRename<CR>
autocmd FileType go map <F5> :GoRun<CR>

let g:airline_theme='oceanicnext'

"-----------------------------------------------------------------------------------------------
"bronson/vim-trailing-whitespace config. If you can use this plugin, you'll write :FixWhitespace
"-----------------------------------------------------------------------------------------------
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=9
endif

"----------
"Syntax C++
"----------
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_no_function_highlight = 0

"------------------
" Golang Settings
"------------------
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" ALE config
let g:ale_linters= {
\   'javascript': ['eslint'],
\   'python': ['pyls', 'flake8'],
\   'vim': ['vint'],
\   'cpp': ['clang'],
\   'c': ['clang'],
\ 	'go': ['gobuild'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'css': ['prettier'],
\   'javascript': ['prettier'],
\   'typescript': ['prettier'],
\   'html': ['prettier'],
\   'json': ['prettier'],
\   'scss': ['prettier'],
\   'yalm': ['prettier'],
\   'python': ['black', 'reorder-python-imports', 'add_blank_lines_for_python_control_statements'],
\   'go': ['gofmt', 'goimports'],
\}
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 0
let g:ale_hover_cursor = 1
let g:ale_disable_lsp = 1
let g:ale_python_pylint_auto_pipenv = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_python_pyls_auto_pipenv = 1
let g:ale_python_flake8_auto_pipenv = 1
let g:ale_python_black_auto_pipenv = 1

" Echodoc config
let g:echodoc#enable_at_startup = 1
