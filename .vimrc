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
set nohlsearch
set nomodeline
set relativenumber
set number
set ruler
" set scrolloff=999
set shiftwidth=2
set smartcase
set smarttab
set softtabstop=2
set tabstop=2
set tw=90
set wrap linebreak nolist

"""" START Vundle Configuration """"
set nobackup

" Disable file type for vundle
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle/Vundle.vim
call vundle#begin('~/.vim/bundle/plugins')

"""""""""""""""""""""""""""""
Plugin 'VundleVim/Vundle.vim'
"""""""""""""""""""""""""""""
Plugin 'bling/vim-airline'
Plugin 'c-brenn/phoenix.vim'
Plugin 'elixir-editors/vim-elixir'
Plugin 'elzr/vim-json'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'kien/ctrlp.vim.git'
Plugin 'klen/python-mode'
Plugin 'lokikl/vim-ctrlp-ag'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'mileszs/ack.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'neomake/neomake'
Plugin 'nginx.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'sheerun/vim-polyglot'
Plugin 'slashmili/alchemist.vim'
Plugin 'slim-template/vim-slim'
Plugin 'sonph/onehalf', {'rtp': 'vim/'}
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-projectionist'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'vim-ruby/vim-ruby'
Plugin 'ayu-theme/ayu-vim'
Plugin 'leafgarland/typescript-vim'
"""""""""""""""""""""""""""""
call vundle#end()
filetype plugin indent on
"""""""""""""""""""""""""""""

" Theme and Styling
" set background=dark
" set t_Co=256
" colorscheme jellybeans
" colorscheme onehalfdark

set termguicolors     " enable true colors support
" let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
colorscheme ayu

" Vim-Airline Configuration
" let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:hybrid_custom_term_colors = 1
let g:hybrid_reduced_contrast = 1

" Vim-Alchemist Configuration
let g:alchemist_tag_disable = 1

" AUTOCMD
autocmd FocusGained * checktime
autocmd! BufWritePost * Neomake
autocmd BufWritePre * :%s/\s\+$//e

" NERDTree Configuration
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let g:NERDTreeWinPos = "left"
let NERDTreeShowLineNumbers=1
" autocmd FileType nerdtree setlocal relativenumber

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
