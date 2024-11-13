" Place %LocalAppData%\nvim\init.vim
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

" Install Jetpack for nvim
" mkdir $env:LocalAppData\nvim-data\site\pack\jetpack\opt\vim-jetpack\plugin
" curl -fLo $env:LocalAppData\nvim-data\site\pack\jetpack\opt\vim-jetpack\plugin\jetpack.vim https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim
packadd vim-jetpack
call jetpack#begin()
Jetpack 'unblevable/quick-scope'
Jetpack 'terryma/vim-multiple-cursors'
Jetpack 'bronson/vim-trailing-whitespace'
call jetpack#end()

" for VS-Code NeoVim
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
