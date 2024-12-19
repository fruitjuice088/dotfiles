" Place %LocalAppData%\nvim\init.vim"
language C
language message C
set encoding=utf-8

set number
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set hls
set clipboard=unnamed
set formatoptions-=cro

inoremap <silent> jj <ESC>
nnoremap <silent> ~~ :s/^\( *-* *\)\(.*\)/\1\~\~\2\~\~<CR>:noh<CR>
nnoremap <silent> ** :s/^\( *-* *\)\(.*\)/\1\*\*\2\*\*<CR>:noh<CR>

" Install Jetpack for nvim
" mkdir $env:LocalAppData\nvim-data\site\pack\jetpack\opt\vim-jetpack\plugin
" curl -fLo $env:LocalAppData\nvim-data\site\pack\jetpack\opt\vim-jetpack\plugin\jetpack.vim https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim
packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack'
Jetpack 'unblevable/quick-scope'
Jetpack 'terryma/vim-multiple-cursors'
Jetpack 'bronson/vim-trailing-whitespace'
call jetpack#end()

"call jetpack#sync()

" for VS-Code NeoVim
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

nnoremap k h
nnoremap t j
nnoremap n k
nnoremap s l
nnoremap - g
nnoremap H :
nnoremap g n
nnoremap G N
nnoremap _ G
nnoremap T J
nnoremap -- gg

vnoremap k h
vnoremap t j
vnoremap n k
vnoremap s l
vnoremap - g
vnoremap H :
vnoremap g n
vnoremap G N
vnoremap _ G
vnoremap T J
vnoremap -- gg

nnoremap zj zt
