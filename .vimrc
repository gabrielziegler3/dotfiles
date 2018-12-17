" Gotta be first
set nocompatible

filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

" ----- Making Vim look good ------------------------------------------
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'dracula/vim'
Plugin 'HenryNewcomer/vim-theme-papaya'
Plugin 'noahfrederick/vim-hemisu'
Plugin 'rakr/vim-one'

" ----- Vim as a programmer's text editor -----------------------------
Plugin 'scrooloose/nerdtree'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'xolox/vim-misc'
" Plugin 'xolox/vim-easytags'
Plugin 'majutsushi/tagbar'
" Plugin 'ctrlpvim/ctrlp.vim'
" Plugin 'vim-scripts/a.vim'

Plugin 'maralla/completor.vim'

Plugin 'scrooloose/nerdcommenter'
Plugin 'chrisbra/Colorizer'

" ----- Working with Git ----------------------------------------------
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'

" ----- Other text editing features -----------------------------------
Plugin 'Raimondi/delimitMate'
" Plugin 'inkarkat/vim-spellcheck'

" ----- man pages, tmux -----------------------------------------------
Plugin 'jez/vim-superman'
Plugin 'christoomey/vim-tmux-navigator'

" ----- Syntax plugins ------------------------------------------------
Plugin 'jez/vim-c0'
Plugin 'jez/vim-ispc'
Plugin 'kchmck/vim-coffee-script'
Plugin 'w0rp/ale'

" ---- Extras/Advanced plugins ----------------------------------------
" Highlight and strip trailing whitespace
Plugin 'ntpeters/vim-better-whitespace'
" Easily surround chunks of text
Plugin 'tpope/vim-surround'
" Align CSV files at commas, align Markdown tables, and more
Plugin 'godlygeek/tabular'
" Automaticall insert the closing HTML tag
Plugin 'HTML-AutoCloseTag'
" Make tmux look like vim-airline (read README for extra instructions)
" Plugin 'edkolev/tmuxline.vim'
" All the other syntax plugins I use
Plugin 'ekalinin/Dockerfile.vim'
" Plugin 'digitaltoad/vim-jade'
" Plugin 'tpope/vim-liquid'
" Plugin 'cakebaker/scss-syntax.vim'
Plugin 'bash-support.vim'

call vundle#end()

filetype plugin indent on

" --- General settings ---
set t_Co=256
set backspace=indent,eol,start
set ruler
set number
set showcmd
set incsearch
set hlsearch
set relativenumber
set cursorline

hi MatchParen cterm=bold ctermbg=green ctermfg=blue
hi CursorLine cterm=NONE ctermbg=darkred ctermfg=white

filetype plugin on

" Allow mouse clicks
" set mouse=a

" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
hi clear SignColumn

" ----- Plugin-Specific Settings --------------------------------------

syntax enable

" if (has("termguicolors"))
    " set termguicolors
" endif

set t_Co=256

" ----- altercation/vim-colors-solarized settings -----
" Toggle this to "light" for light colorscheme
set background=dark

" Set the colorscheme
color papaya_original

hi clear SpellBad
hi SpellBad cterm=bold ctermbg=blue ctermfg=green
hi SpellCap cterm=underline ctermfg=red
hi SpellLocal cterm=bold ctermbg=green ctermfg=blue
hi SpellRare cterm=underline  ctermfg=red

" ----- bling/vim-airline settings -----
" Always show statusbar
set laststatus=2

" Fancy arrow symbols, requires a patched font
" To install a patched font, run over to
"     https://github.com/abertsch/Menlo-for-Powerline
" download all the .ttf files, double-click on them and click "Install"
" Finally, uncomment the next line
let g:airline_powerline_fonts = 1

" Show PASTE if in paste mode
let g:airline_detect_paste=1

" Show airline for tabs too
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='ayu_mirage'

" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with \t
"nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" To have NERDTree always open on startup
let g:nerdtree_tabs_open_on_console_startup = 0

" ---- Colorizer ----
" let g:colorizer_auto_color = 1


" Use deoplete.
let g:deoplete#enable_at_startup = 1

"------NERD TREE--------"
map <C-n> :NERDTreeToggle<CR>

"------NERD Commenter--------"
let NERDSpaceDelims=1

" ----- ALE settings -----
" Check Python files with flake8 and pylint.
" Enable completion where available.
let g:ale_completion_enabled = 1

let b:ale_linters = ['flake8', 'pylint', 'luacheck']
" Fix Python files with autopep8 and yapf.
let b:ale_fixers = ['autopep8', 'yapf']
" Disable warnings about trailing whitespace for Python files.
let b:ale_warn_about_trailing_whitespace = 0

" ----- xolox/vim-easytags settings -----
" Where to look for tags files
set tags=./tags;,~/.vimtags
" Sensible defaults
let g:easytags_events = ['BufReadPost', 'BufWritePost']
let g:easytags_async = 1
let g:easytags_dynamic_files = 2
let g:easytags_resolve_links = 1
let g:easytags_suppress_ctags_warning = 1

" ----- majutsushi/tagbar settings -----
" Open/close tagbar with \b
" nmap <silent> <leader>b :TagbarToggle<CR>
" Uncomment to open tagbar automatically whenever possible
"autocmd BufEnter * nested :call tagbar#autoopen(0)

" ----- Completor -----
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"

" ----- Spellcheck -----
" Spell-check set to F6:
map <F6> :setlocal spell! spelllang=en_gb,pt_br<CR>

" ----- Fugitive -----
" Toggle git blame
map <F7> :Gblame<CR>

"Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

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

" ----- jez/vim-superman settings -----
" better man page support
noremap K :SuperMan <cword><CR>

