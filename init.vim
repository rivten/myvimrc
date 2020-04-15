" BY HUGO VIALA.
"
" This is my vimrc file.
" There are two plugins that might need direct install :
" - qgrep
" - tek256/simple-dark I think vundle also needs to be installed manually
"
" Also, this might only work in neovim. Not sure at all about pure vanilla vim
" Now, the whole windows/linux stuff starts to appear.
" 
" ON WINDOWS :
" All plugins should be located in C:\Users\my_user\vimfiles\.
" THIS file should be located in C:\Users\my_user\AppData\Local\nvim\init.vim
"
" ON LINUX :
" All plugins should be located in ~/.vim
" THIS file should be located in ~/.config/nvim/init.vim

filetype off
set nocompatible
if has("win32")
	set rtp+=C:\Users\hviala\vimfiles\bundle\Vundle.vim
	call vundle#begin("C:\Users\hviala\vimfiles\bundle");
else
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin('~/.vim/bundle')
endif
Plugin 'gmarik/Vundle.vim'

"Plugin 'bling/vim-airline'
"Plugin 'vim-airline/vim-airline-themes'
"Plugin 'scrooloose/nerdtree'
"Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'plasticboy/vim-markdown'
Plugin 'tikhomirov/vim-glsl'
Plugin 'morhetz/gruvbox'
Plugin 'vim-scripts/grep.vim'
Plugin 'bkad/CamelCaseMotion'
Plugin 'vim-scripts/argtextobj.vim'
Plugin 'junegunn/goyo.vim'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'ziglang/zig.vim'
if has("win32")
	Plugin 'nfvs/vim-perforce'
endif
Plugin 'tek256/simple-dark'

call vundle#end()
" enable filetype plugins
filetype plugin on
filetype indent on
" color highlight syntax
syntax enable

set background=dark
colorscheme gruvbox

" basic stuff
set encoding=utf-8

" about tabs
set tabstop=4
set softtabstop=4
" set expandtab
set shiftwidth=4
set smarttab
set autoindent

" show current line
set cursorline

" changing language to english because why not
set langmenu=en_US.UTF-8  
":language mes EN

" removing useless shit
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

let c_no_curly_error=1

if has("gui_running")
	"fullscreen at startup
	"au GUIEnter * simalt ~n 
	set lines=999 columns=999
endif

" displaying line numbers
set relativenumber
"set number

function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
    set number
  else
    set relativenumber
    set nonumber
  endif
endfunc

nnoremap <silent><C-a> :call NumberToggle()<cr>

" quick close QuickFix window (for build)
nnoremap <Leader>k :ccl<cr>


" dealing with azerty shit
nmap z w
nmap <C-T> <C-]>

set langmap=à@,è`,é~,ç_,’`,ù%
lmap à @
lmap è `
lmap é ~
lmap ç _
lmap ù %
lmap ’ `

" no more esc shit
inoremap jk <ESC>

" changing leader key to space
let mapleader=","

" setting a badass font
"set guifont=Iosevka\ Term\ Regular\ 14
set guifont=LiberationMono\ 12

" trying to do autocomplete on file search
set wildmode=longest,list,full
set wildmenu

" automatically reload modified files
set autoread

" search is now moar beautiful
set hlsearch
set incsearch

" <Ctrl-l> redraws the screen and removes any search highlighting.
nnoremap <silent> <C-l> :nohl<CR><C-l>

"highlight matching parenthesis, brackets, ...
set showmatch

" space now puts us at the center of the screen
nnoremap <Space> zz


" enable folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=indent

inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" no more beeps
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" no backup
set nobackup
set nowb
set noswapfile

set switchbuf=useopen,split

""""""""""""""""""""""""""""""""""""""""""""""
"          CamelCaseMotion                   "
""""""""""""""""""""""""""""""""""""""""""""""

call camelcasemotion#CreateMotionMappings('<leader>')
map <silent> <leader>e <Plug>CamelCaseMotion_e
map <silent> <leader>v <Plug>CamelCaseMotion_b
map <silent> <leader>w <Plug>CamelCaseMotion_w
map <silent> <leader>z <Plug>CamelCaseMotion_w

"""""""""""""""""""""""""""""""""""""""""""""
"         BUILD BATCH                       "
"""""""""""""""""""""""""""""""""""""""""""""
let g:asyncrun_open = 3
function! s:build()
	if(has("win32"))
		compiler msvc
	endif
	:AsyncRun ./build.sh
endfunction

command! Build call s:build()
map <Leader>b :Build<cr>

""""""""""""""""""""""""""""""""""""""""""""""
"            NERDTree                        "
""""""""""""""""""""""""""""""""""""""""""""""
let NERDTreeIgnore=['\.pyc$', '\~$', '\.class$', '\.obj$', '\.exe$', '\.sln$', '.\vcxproj$', '\.filters$', '\.user$']
nmap <leader>ne : NERDTree<cr>


" Specific ubi stuff
if(has("win32"))
	" Perforce
	nmap <leader>p :P4edit


	" Build scripts
	command! BuildScimitarTool call s:BuildScimitarTool_()
	nmap <leader>bt :BuildScimitarTool<cr>

	function! s:BuildScimitarEngine_()
		":Dispatch c:/scripts/build_scimitar_engine.bat
		compiler msbuild
		:AsyncRun c:/scripts/build_scimitar_engine.bat
	endfunction

	command! BuildScimitarEngine call s:BuildScimitarEngine_()
	nmap <leader>be :BuildScimitarEngine<cr> 

	function! s:GenerateProjects_()
		":Dispatch c:/scripts/generate_projects.bat
		:AsyncRun c:/scripts/generate_projects.bat
	endfunction

	command! GenerateProjects call s:GenerateProjects_()
	nmap <leader>gp :GenerateProjects<cr>

	set errorformat-=completed%s
endif

" Convert slashes to backslashes for Windows.
if has('win32')
  nmap ,cs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>
  nmap ,cl :let @*=substitute(expand("%:p"), "\\", "/", "g")<CR>
  nmap ,cm :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>

  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap ,c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>
else
  nmap ,cs :let @*=expand("%")<CR>
  nmap ,cl :let @*=expand("%:p")<CR>
endif


if has("win32")
	set shellslash
endif

set path+=**

set wildignore+=**/build/**
set wildignore+=**/bin/**
set wildignore+=**/zig-cache/**
set wildignore+=**/data/**