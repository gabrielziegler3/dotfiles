" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
source ~/.config/nvim/plugins.vim
call plug#end()

luafile ~/.config/nvim/compe-config.lua
luafile ~/.config/nvim/python-lsp.lua
luafile ~/.config/nvim/bash-lsp.lua

filetype plugin indent on

" --- General settings ---
" set t_Co=256
set t_ut=
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set relativenumber
set cursorline
set tabstop=4
set shiftwidth=4
set expandtab

" Set folding methods for Latex and Python files
augroup FoldingMethods
    autocmd!
    autocmd FileType tex set foldmethod=marker
    " autocmd FileType python set foldmethod=indent
    " autocmd FileType python set foldnestmax=1
augroup END

augroup CompileDocument
    autocmd!
    autocmd FileType tex map <F3> :wall<cr>:!compilation_files/compile full<cr><esc>
    autocmd FileType markdown map <F3> :wall<cr>:!docker run --privileged --rm -u `id -u`:`id -g` -v $(pwd):/pandoc dalibo/pandocker % -o output.pdf<cr><esc>
augroup END

if (has('nvim'))
    set inccommand=nosplit
    " Unset gui cursor in nVim
    set guifont=Inconsolata
    set guicursor=
    set emoji
endif

" Figure out the system Python for Neovim.
if exists("$VIRTUAL_ENV")
    let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
else
    let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

" hi MatchParen cterm=bold ctermbg=green ctermfg=blue

filetype plugin on

" ----- Plugin-Specific Settings --------------------------------------
syntax enable

" if (has("termguicolors"))
"     set termguicolors
" endif

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

if has('terminal') && !(&term ==# 'xterm-kitty') && !(&term ==# 'xterm-256color')
    " Avoid setting this variable when it is not absolutely neccesary
    " since it is very very slow (10 times as long startuptime as
    " everything else combined)
    set term=xterm-256color " Falls back to 'xterm' if it does not start with xtert
endif

" Spell check error highlighting
hi clear SpellBad
hi SpellBad cterm=underline ctermfg=white ctermbg=red
hi SpellCap cterm=underline ctermfg=red
hi SpellLocal cterm=underline ctermbg=green ctermfg=blue
hi SpellRare cterm=underline  ctermfg=red

" ----- altercation/vim-colors-solarized settings -----
" Toggle this to "light" for light colorscheme
set background=dark

" Set the colorscheme
colorscheme onehalfdark

" Toggle background transparency
" hi Normal guibg=NONE ctermbg=NONE ctermfg=NONE
" hi CursorLine cterm=bold ctermbg=darkred ctermfg=white guibg=Black

" let ayucolor="mirage"

" Cycle suggestion with TAB
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" ----- lightline -----
let g:lightline = {
      \ 'colorscheme': 'onehalfdark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype' ] ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead',
      \ },
      \ }

" ---- Colorizer ----
" let g:colorizer_auto_color = 1

"------NERD TREE--------"
map <C-n> :NERDTreeToggle<CR>

"------NERD Commenter--------"
let NERDSpaceDelims=1

"------ better whitespace --------"
let g:strip_whitespace_on_save=1
let g:better_whitespace_enabled=1
let g:strip_whitespace_confirm=0

" ----- Spellcheck -----
" Spell-check set to F6:
" set nospell
map <F6> :setlocal spell! spelllang=en_gb,pt_br<CR>
let g:languagetool_jar="/usr/share/java/languagetool/languagetool-commandline.jar"

" ----- Fugitive -----
" Toggle git blame
map <F7> :Git blame<CR>

" ----- airblade/vim-gitgutter settings -----
" In vim-airline, only display "hunks" if the diff is non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" ----- Raimondi/delimitMate settings -----
let delimitMate_expand_cr = 1
augroup mydelimitMate
 au!
 au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
 au FileType tex let b:delimitMate_quotes = ""
 au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
 au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
augroup END

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md'

" Syntax Highlight conf files
au BufEnter,BufRead *conf* setf dosini

" Ctrl r when in visual mode for quick replacing
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" ------- Gutter config
" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
highlight clear SignColumn

" Fix SQL problem
let g:omni_sql_no_default_maps = 1

" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

let g:tmux_navigator_no_mappings = 1
