"""""""""""""""""""""""""""""""""""""
" My Vim Config
"""""""""""""""""""""""""""""""""""""
set nocompatible
syntax on

set autoread
set backspace=2
set backspace=indent,eol,start
set bs=2
set clipboard+=unnamed
set colorcolumn=90
set cursorline
set directory=$HOME/.vim/swapfiles/
set encoding=utf8
set expandtab
set fo+=t
set guioptions-=e
set hidden
set incsearch
set laststatus=2
set nomodeline
set noswapfile
set relativenumber
set number
set ruler
set shiftwidth=2
set smartcase
set smarttab
set softtabstop=2
set tabstop=2
set tw=98
set wrap linebreak nolist
set splitright
set splitbelow
set modifiable
set scrolloff=10
" set scrolloff=999

"""" START Vundle Configuration """"
set nobackup

" Disable file type for vundle
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim " in OS X
call vundle#begin('~/.vim/bundle/plugins')

"""""""""""""""""""""""""""""
Plugin 'VundleVim/Vundle.vim'
"""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""
" Everyday library plugins
"""""""""""""""""""""""""""""
Plugin 'c-brenn/phoenix.vim'
Plugin 'elixir-editors/vim-elixir'
Plugin 'elzr/vim-json'
Plugin 'nginx.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'slashmili/alchemist.vim'
Plugin 'slim-template/vim-slim'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'leafgarland/typescript-vim'
Plugin 'fatih/vim-go'
Plugin 'kchmck/vim-coffee-script'
" Plugin 'sheerun/vim-polyglot'
"""""""""""""""""""""""""""""
" Extension plugins
"""""""""""""""""""""""""""""
Plugin 'vim-airline/vim-airline'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'kien/ctrlp.vim.git'
Plugin 'lokikl/vim-ctrlp-ag'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'mileszs/ack.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'neomake/neomake'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-surround'
Plugin 'Yggdroot/indentLine'
Plugin 'lifepillar/vim-mucomplete'
"""""""""""""""""""""""""""""
" Colorscheme
"""""""""""""""""""""""""""""
Plugin 'morhetz/gruvbox'
Plugin 'tomasiser/vim-code-dark'
Plugin 'tomasr/molokai'
Plugin 'owickstrom/vim-colors-paramount'

call vundle#end()
filetype plugin indent on
"""""""""""""""""""""""""""""

" colorscheme paramount
" colorscheme molokai
" colorscheme gruvbox
let g:codedark_conservative = 1
colorscheme codedark
" highlight LineNr ctermbg=236
" highlight Search ctermbg=236

" Vim-Airline Configuration
let g:airline_theme = 'codedark'

" Vim-Alchemist Configuration
let g:alchemist_tag_disable = 0

" AUTOCMD
autocmd FocusGained * checktime
" autocmd! BufWritePost * Neomake
autocmd BufWritePre * :%s/\s\+$//e
autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2

" NERDTree Configuration
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let g:NERDTreeWinPos = "left"
let NERDTreeShowLineNumbers=1
autocmd FileType nerdtree setlocal relativenumber
" let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" CTRLP
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
let g:ctrlp_max_depth = 25
let g:ctrlp_max_files = 10000
let g:ctrlp_show_hidden = 1
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\.git$\|\.hg$\|\.svn$\|bower_components$\|dist$\|node_modules$\|project_files$\|test$\|deps$\|vendor$\|_build$',
    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

" Ag
let g:ag_working_path_mode="r"

" NNOREMAP AND VNOREMAP
inoremap \j <Esc>:m .+1<CR>==gi
inoremap \k <Esc>:m .-2<CR>==gi
nnoremap <c-f> :CtrlPag<cr>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <F5> :buffers<CR>:buffer<Space>
nnoremap <leader>ca :CtrlPagLocate
nnoremap <leader>cp :CtrlPagPrevious<cr>
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>
nnoremap \j :m .+1<CR>==
nnoremap \k :m .-2<CR>==
vnoremap <c-f> :CtrlPagVisual<cr>
vnoremap \j :m '>+1<CR>gv=gv
vnoremap \k :m '<-2<CR>gv=gv

" Gutentags
let g:gutentags_cache_dir = '~/.tags_cache'

" vim-go lsp
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'

" indentation
let g:indentLine_char = '┆'
let g:indentLine_color_term = 236

" autocomplete
set completeopt+=menuone

