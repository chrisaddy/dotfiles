set runtimepath^=~/.vim runtimepath+=~/.vim/after

let g:session_autoload = 'no'
let g:session_autosave = 'no'

set relativenumber
set termguicolors
syntax on
set ruler
filetype plugin indent on
set mouse=a
augroup TERMINAL
	autocmd!
	" autocmd BufWinEnter,WinEnter term://* startinsert
	autocmd BufLeave term://* stopinsert
	au TermOpen * setlocal nonumber
	au TermOpen * setlocal norelativenumber
augroup end

let g:vim_bootstrap_langs = "python,go"
let g:vim_bootstrap_editor = "nvim"
let g:loaded_gzip               =  1
let g:loaded_tarPlugin          =  1
let g:loaded_zipPlugin          =  1
let g:loaded_2html_plugin       =  1

let g:loaded_rrhelper           =  1
let g:loaded_remote_plugins     =  1
let g:loaded_netrw              =  1
let g:loaded_netrwPlugin        =  1

let mapleader="\<SPACE>"

augroup PLUGGED
	if empty(glob('~/.vim/autoload/plug.vim'))  " Vim
		silent !curl -fo ~/.vim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
		autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
	endif
augroup end

call plug#begin('~/.vim/plugged')
" autocompletion/syntax
let g:mymu_enabled=1
let g:mylsc_enabled=1
Plug 'lifepillar/vim-mucomplete', {'on' : []}
Plug 'jonasw234/vim-mucomplete-minisnip'
Plug 'dense-analysis/ale'

" zettelkasten
Plug 'vimwiki/vimwiki'
let g:vimwiki_list = [{'path': '~/zettelkasten', 'syntax': 'markdown', 'ext': '.md'}]
au Filetype vimwiki setlocal shiftwidth=4 tabstop=4 noexpandtab
Plug 'dhruvasagar/vim-dotoo'
" nmap <Nop> <Plug>(dotoo-capture)
Plug 'tpope/vim-speeddating', { 'for': [ 'org', 'dotoo', 'rec' ] }

" commmenting
Plug 'tpope/vim-commentary'

" git
Plug 'tpope/vim-fugitive', { 'on': ['Gstatus', 'Gpush', 'Gedit', 'Ggrep'] }
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gp :Git push<CR>
nnoremap <leader>pr :!gh pr create --title


Plug 'mhinz/vim-signify'
set updatetime=100

" sessions
Plug 'tpope/vim-obsession'
let g:sessions_dir = '~/vim-sessions'
exec 'nnoremap <Leader>ss :Obsession ' . g:sessions_dir . '/*.vim<C-D><BS><BS><BS><BS><BS>'
exec 'nnoremap <Leader>sr :so ' . g:sessions_dir. '/*.vim<C-D><BS><BS><BS><BS><BS>'

" python
Plug 'psf/black'
let g:autofmt_autosave = 1
autocmd BufWritePre *.py execute ':Black'

" terraform
Plug 'hashivim/vim-terraform'
let g:terraform_fmt_on_save = 1

" terminal
Plug 'voldikss/vim-floaterm'
nnoremap <leader>tn :FloatermNew<CR>
nnoremap <leader>tk :FloatermKill<CR>
nnoremap <leader>mb :FloatermNew --autoclose=0 make build<CR>
nnoremap <leader>mbr :FloatermNew --autoclose=0 make build run<CR>
nnoremap <leader>mt :FloatermNew --autoclose=0 make test<CR>
let g:floaterm_keymap_toggle = '<F12>'

" file nav
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
set rtp+=/usr/local/opt/fzf
nnoremap <leader>f :GFiles<CR>
Plug 'scrooloose/nerdtree'
nnoremap <leader>t :NERDTreeToggle<CR>
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeShowHidden = 1
let g:NERDTreeChDirMode = 2
nnoremap <leader>cd :cd %:p:h<CR>:pwd<CR>

" undo
Plug 'mbbill/undotree'
if has("persistent_undo")
	set undodir=$HOME"/.undodir"
	set undofile
endif

" jupyter notebooks
Plug 'szymonmaszke/vimpyter'
autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>

" style == function bruh
Plug 'Gavinok/spaceway.vim'
Plug 'dracula/vim'
Plug 'challenger-deep-theme/vim', {'as': 'challenger-deep'}
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'ap/vim-buftabline'

if executable('go')
	Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' , 'on' : [] }
	let g:Hexokinase_highlighters = [ 'backgroundfull' ]
endif

Plug 'kien/rainbow_parentheses.vim'
Plug 'eraserhd/parinfer-rust'
Plug 'tpope/vim-surround'
" rainbow parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
call plug#end()

augroup LazyLoadPlug
	autocmd!
	autocmd CursorHold,CursorHoldI *
				\ call plug#load('vim-fugitive') |
				\ call plug#load('vim-hexokinase') |
				\ autocmd! LazyLoadPlug
augroup end

if has('gui_running')
	call dotvim#LoadGui()
elseif exists('g:colors_name') && g:colors_name !=# 'acme'
	hi Normal      guibg=NONE
	hi ColorColumn guibg=NONE
	hi SignColumn  guibg=NONE
	hi Folded      guibg=NONE
	hi Conceal     guibg=NONE
	hi Terminal    guibg=NONE
	hi LineNr      guibg=NONE
endif

" aliases
function! SetupCommandAlias(from, to)
	exec 'cnoreabbrev <expr> '.a:from
				\ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
				\ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction
call SetupCommandAlias('git','Git')
call SetupCommandAlias('cp','!cp')
call SetupCommandAlias('mv','!mv')
call SetupCommandAlias('rm','!rm')
call SetupCommandAlias('mkdir','!mkdir')

" backup escape options
inoremap kj <Esc>

" window/buffer navigation
nnoremap <leader>h <C-W><C-H> " move left one window
nnoremap <leader>j <C-W><C-J> " move down one window
nnoremap <leader>k <C-W><C-K> " move up one window
nnoremap <leader>l <C-W><C-L> " move right one window
nnoremap <leader>n :bnext<CR>
nnoremap <leader>p :bprevious<CR>

" window splitting
nnoremap <leader>J :split<CR>
nnoremap <leader>L :vsplit<CR>

iab cloud butt

nmap <leader><SPACE> :

colorscheme spaceway
" colorscheme dracula
highlight Normal ctermbg=NONE
highlight Conceal ctermbg=NONE
let g:spaceway_termcolors=256
set noshowmode

function ObsessionName()
	let session_name = ''
	if exists('v:this_session') && v:this_session != ''
		let session_name = ' ' . v:this_session
	else
		let session_name = 'no-session'
	endif
	return session_name
endfunction

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ],
      \             [ 'branch' ],
      \             [ 'obsessionStatus', 'obsessionName' ]
      \           ]
      \ },
      \ 'component': { 'branch': gitbranch#name(),
      \                'obsessionStatus': '%{ObsessionStatus()}'}
      \ }

