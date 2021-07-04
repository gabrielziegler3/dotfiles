" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" ----- Making Vim look good ------------------------------------------
" Plug 'vim-airline/vim-airline'
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'rainglow/vim'
Plug 'vim-scripts/buttercream.vim'

" ----- Vim as a programmer's text editor -----------------------------
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'xolox/vim-misc'
Plug 'majutsushi/tagbar'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdcommenter'
Plug 'chrisbra/Colorizer'
Plug 'dart-lang/dart-vim-plugin'
Plug 'elzr/vim-json'
" Plug 'ycm-core/YouCompleteMe'
Plug 'chrisbra/csv.vim'
Plug 'dpelle/vim-LanguageTool'
Plug 'lervag/vimtex'

" ----- Themes -----------------------------
Plug 'sonph/onehalf', { 'rtp': 'vim' }
" Plug 'vim-airline/vim-airline-themes'
Plug 'HenryNewcomer/vim-theme-papaya'
Plug 'cseelus/vim-colors-lucid'
Plug 'rakr/vim-one'
Plug 'ayu-theme/ayu-vim'
Plug 'NLKNguyen/papercolor-theme'


" ----- Working with Git ----------------------------------------------
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" ----- Other text editing features -----------------------------------
Plug 'Raimondi/delimitMate'

" ----- man pages, tmux -----------------------------------------------
Plug 'jez/vim-superman'

" ----- Syntax plugins ------------------------------------------------
Plug 'jez/vim-c0'
Plug 'jez/vim-ispc'
Plug 'kchmck/vim-coffee-script'
" Plug 'w0rp/ale'
" Plug 'kamykn/spelunker.vim'
" Plug 'dpelle/vim-LanguageTool'
Plug 'rhysd/vim-grammarous'
Plug 'kamykn/popup-menu.nvim'

" ---- Extras/Advanced plugins ----------------------------------------
" Highlight and strip trailing whitespace
" Plug 'ntpeters/vim-better-whitespace'
" Easily surround chunks of text
Plug 'tpope/vim-surround'
" Align CSV files at commas, align Markdown tables, and more
Plug 'godlygeek/tabular'
" Automaticall insert the closing HTML tag
" Make tmux look like vim-airline (read README for extra instructions)
" Plug 'edkolev/tmuxline.vim'
" All the other syntax plugins I use
Plug 'ekalinin/Dockerfile.vim'

call plug#end()

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
" set cursorline
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

let ayucolor="mirage"

" Cycle suggestion with TAB
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" ----- lightline -----
let g:lightline = {
      \ 'colorscheme': 'onehalfdark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
" ----- bling/vim-airline settings -----
" " Always show statusbar
" " set statusline^=%{coc#status()}
" set laststatus=2
" 
" " Fancy arrow symbols, requires a patched font
" " To install a patched font, run over to
" "     https://github.com/abertsch/Menlo-for-Powerline
" " download all the .ttf files, double-click on them and click "Install"
" " Finally, uncomment the next line
" let g:airline_powerline_fonts = 1
" 
" " Show PASTE if in paste mode
" let g:airline_detect_paste=1
" 
" " Show airline for tabs too
" let g:airline#extensions#tabline#enabled = 1
" " let g:airline_theme='lucius'
" let g:airline_theme='onehalfdark'


" ----- jistr/vim-nerdtree-tabs -----
" Open/close NERDTree Tabs with \t
"nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
" To have NERDTree always open on startup
let g:nerdtree_tabs_open_on_console_startup = 0

" ---- Colorizer ----
" let g:colorizer_auto_color = 1

"------NERD TREE--------"
map <C-n> :NERDTreeToggle<CR>

"------NERD Commenter--------"
let NERDSpaceDelims=1

" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" ----- Spellcheck -----
" Spell-check set to F6:
" set nospell
map <F6> :setlocal spell! spelllang=en_gb,pt_br<CR>
let g:languagetool_jar="/usr/share/java/languagetool/languagetool-commandline.jar"

" ----- Fugitive -----
" Toggle git blame
map <F7> :Gblame<CR>

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

" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
"
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.md'

" Syntax Highlight conf files
au BufEnter,BufRead *conf* setf dosini

" Ctrl r when in visual mode for quick replacing
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

" COC CONFIG
"
" Run prettier on save
" command! -nargs=0 Prettier :CocCommand prettier.formatFile
" if hidden is not set, TextEdit might fail.
" set hidden
"
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
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

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" ------- Gutter config
" We need this for plugins like Syntastic and vim-gitgutter which put symbols
" in the sign column.
highlight clear SignColumn

" Fix SQL problem
let g:omni_sql_no_default_maps = 1
