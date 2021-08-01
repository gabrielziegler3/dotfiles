" ----- Making Vim look good ------------------------------------------
Plug 'itchyny/lightline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'rainglow/vim'
Plug 'vim-scripts/buttercream.vim'

" Nvim LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'

" ----- Vim as a programmer's text editor -----------------------------
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'alvan/vim-closetag'
Plug 'scrooloose/nerdcommenter'
Plug 'chrisbra/Colorizer'
Plug 'elzr/vim-json'
Plug 'chrisbra/csv.vim'
Plug 'lervag/vimtex'
Plug 'sheerun/vim-polyglot'

" ----- Themes -----------------------------
Plug 'sonph/onehalf', { 'rtp': 'vim' }
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

" ----- Syntax plugins ------------------------------------------------
" Plug 'w0rp/ale'
" Plug 'kamykn/spelunker.vim'
Plug 'rhysd/vim-grammarous'
Plug 'kamykn/popup-menu.nvim'

" ---- Extras/Advanced plugins ----------------------------------------
" Highlight and strip trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" Easily surround chunks of text
Plug 'tpope/vim-surround'
" Align CSV files at commas, align Markdown tables, and more
Plug 'godlygeek/tabular'
" Automaticall insert the closing HTML tag
" All the other syntax plugins I use
Plug 'ekalinin/Dockerfile.vim'

