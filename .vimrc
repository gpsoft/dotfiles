scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac

"Not necessary if you use 'vimfiles' instead of '.vim'.
"if ( (has('win32') || has('win64')) &&
"     !exists("g:loaded_pathogen"))
"    "Add .vim to runtime path for Win.
"    "But this causes a problem when re-loading rc(pathogen can't find plagins?),
"    "so do it only first load.
"    set runtimepath=~/.vim,$VIMRUNTIME
"endif

"Pathogen.
let g:pathogen_disabled = []  "Plugins you want to disable temporalily.
execute pathogen#infect()
execute pathogen#helptags()
syntax on
filetype plugin indent on

"Auto commands.
augroup vimrc
    autocmd!

    "Tab.
    autocmd FileType vim setlocal sw=4 sts=4 ts=4 et
    autocmd FileType ruby setlocal sw=2 sts=2 ts=2 et
    autocmd FileType markdown setlocal sw=2 sts=2 ts=2 et
    autocmd FileType java setlocal sw=4 sts=4 ts=4 et
    autocmd FileType javascript setlocal sw=4 sts=4 ts=4 noet
    autocmd FileType yaml setlocal sw=4 sts=4 ts=4 et
    autocmd FileType json setlocal sw=4 sts=4 ts=4 et
    autocmd FileType php setlocal sw=4 sts=4 ts=4 noet
    autocmd FileType html setlocal sw=4 sts=4 ts=4 noet
    autocmd FileType sh setlocal sw=4 sts=4 ts=4 et
    autocmd FileType xml setlocal sw=4 sts=4 ts=4

    "Map file extension to file type.
    autocmd BufNewFile,BufRead *.ctp set filetype=php
    if has('mac')
        " MacVimでは、mdを開いた後でsplitするとfiletypeがmodula2に戻ってしまう。
        " しかたないのでvim本体を修正した。
        " /Applications/MacVim.app/Contents/Resources/vim/runtime/filetype.vim
    else
        autocmd BufNewFile,BufRead *.md set filetype=markdown
    endif

    autocmd FileType vim setlocal keywordprg=:help
    autocmd FileType clojure setlocal lispwords+=defproject,provided,tabular,domonad,with-monad,defmonad

    autocmd FileType clojure call EnableClojureFolding()
    function! GetClojureFold()
        if getline(v:lnum) =~ '^('
            return ">1"
        else
            return "="
        endif
    endfunction
    function! EnableClojureFolding()
        setlocal foldexpr=GetClojureFold()
        setlocal foldmethod=expr
        setlocal nofoldenable
        nnoremap <Space> za
    endfunction

    "autocmd bufwritepost .vimrc source $MYVIMRC
    autocmd bufwritepost *.md call previm#refresh()
augroup END

"--------------------------------- Plugins ---------------------------------
"NETRW
" let g:netrw_keepdir=0
let g:netrw_keepj="keepj"
" let g:netrw_liststyle=3
" let g:netrw_silent=1

"MATCHIT
runtime macros/matchit.vim

"MRU
let MRU_Max_Entries = 100
let MRU_Exclude_Files = "^crontab\."

"LIGHTLINE
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"\u2b64":""}',
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \ },
      \ 'component_visible_condition': {
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())',
      \ },
      \ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
      \ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
      \ }
function! MyFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? "\u2b60"._ : ''
  endif
  return ''
endfunction
function! AlterWombat()
    "Inactive line is too dark, let's lighten it up a bit.
    hi LightLineLeft_inactive_0 ctermbg=248 ctermfg=234 guibg=#a0a0a0 guifg=#000000
    hi LightLineLeft_inactive_0_1 ctermbg=238 ctermfg=248 guibg=#444444 guifg=#a0a0a0
    hi LightLineMiddle_inactive ctermbg=238 guibg=#444444
    hi LightLineRight_inactive_1_2 ctermbg=238 ctermfg=238 guibg=#444444 guifg=#444444
endfunction
autocmd VimEnter * call AlterWombat()
"      "It doesn't work in CUI; too early.
autocmd BufRead * call AlterWombat()

"VIM-CLOJURE-STATIC
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^\(future-\)\?facts\?$', '^prerequisites\?$']

"RAINBOW-PAREN
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
let g:rbpt_max = 8
let g:rbpt_loadcmd_toggle = 0
autocmd VimEnter * RainbowParenthesesToggle
autocmd Syntax * RainbowParenthesesLoadRound
autocmd Syntax * RainbowParenthesesLoadSquare
autocmd Syntax * RainbowParenthesesLoadBraces

"VIM-JSON
let g:vim_json_syntax_conceal = 0

"--------------------------------- Options ---------------------------------
set t_Co=256
colorscheme slate

"Block cursor in terminal.
let &t_ti.="\e[1 q"
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"
let &t_te.="\e[0 q"
" set t_ve+=[?81;0;112c

set notitle
set suffixesadd=.clj,.rb  "for gf
set nrformats=            "format for <C-A> or <C-X>
set hidden
set smartcase
set infercase
set incsearch
"set nowrapscan

set noundofile
set backup
if has('mac')
  set backupdir=/var/tmp/bak
  set backupskip=/tmp/*,/private/tmp/*
elseif has('unix')
else
  set backupdir=c:\tmp\apptmp\bak
  set directory=c:\tmp\apptmp\swp
  if $COMPUTERNAME == "ANTARES"
    set backupdir=d:\tmp\apptmp\bak
    set directory=d:\tmp\apptmp\swp
  endif
endif

set pastetoggle=<F2>
set showmode

set tw=0
autocmd FileType text setlocal tw=0
        "Global setting doesn't work for text filetype?

highlight ColorColumn ctermbg=magenta guibg=Magenta
call matchadd('ColorColumn', '\%82v', 100)

set number
"Relativenumber can make scroll slow in terminal.
" set relativenumber

if ( has('win32') || has('win64') )
    set listchars=    " better to clear lcs before setting ambiwidth to auto or double; or you could get E834.
    set ambiwidth=auto
    "Moved list setting to .gvimrc.
    "set list lcs=tab:»\ ,eol:¬,trail:·
else
    set ambiwidth=single
    set list lcs=tab:»\ ,eol:¬,trail:·
endif

set laststatus=2

"--------------------------------- Custom commands -------------------------
"Clojure REPL.
if has('mac')
  function! Repl(dir)
    let script = "!osascript"
      \ . " -e 'tell application \"iTerm\"'"
      \ . " -e '  make new terminal'"
      \ . " -e '  tell the current terminal'"
      \ . " -e '    activate current session'"
      \ . " -e '    launch session \"Default session\"'"
      \ . " -e '    tell the last session'"
      \ . " -e '      write text \"cd " . a:dir . "; lein repl\"'"
      \ . " -e '    end tell'"
      \ . " -e '    end tell'"
      \ . " -e 'end tell'"
    execute script
  endfunction
  command! Repl silent! call Repl(expand("%:p:h"))
elseif has('unix')
else
  command! Repl !start cmd.exe /c cd /d "%:h"&& lein.bat repl
endif

"Command prompt for Windows.
if has('mac')
elseif has('unix')
else
  command! Dos !start cmd.exe /k cd /d "%:h"
endif

"--------------------------------- Experimental ----------------------------
let php_htmlInStrings=1

let g:html_indent_script1="inc"
let g:html_indent_style1="inc"
let g:html_indent_inctags="html,body,head"

"let g:UltiSnipsExpandTrigger="<tab>"
"let g:UltiSnipsJumpForwardTrigger="<tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

":Qargs
"to set arglist to files in quickfix list.
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
	let buffer_numbers = {}
	for quickfix_item in getqlist()
		let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
	endfor
	return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

"let g:EasyMotion_use_migemo = 1

"let g:sexp_enable_insert_mode_mappings = 0

"let g:haskell_conceal = 0

"let g:clojure_fold = 1
let g:clojure_highlight_references = 1
let g:clojure_align_multiline_strings = 1

nmap <C-Q> :q<CR>
nmap <C-T> :w<CR>





"--------------------------------- Keymaps ---------------------------------
let mapleader = ","
noremap \ ,
nmap <Leader>E :Ex<CR>
nmap <Leader>S :Sex<CR>
nmap <Leader>V :Vex<CR>
nmap <Leader>q :copen 10<CR><C-w>J
nmap <Leader>ve :split $HOME/dotfiles/.vimrc<CR>
nmap <Leader>vs :so $MYVIMRC<CR>:RainbowParenthesesActivate<CR>
                   "After re-loading .vimrc rainbow paren gets off.
nmap <Leader>m :MRU<CR>
nmap <Leader>l :BufExplorer<CR>
nmap <Leader>o :CtrlPMixed<CR>
nmap <Leader>r :OverCommandLine<CR>%s/
nmap <Leader>p :PrevimOpen<CR>
nmap <C-F> <Leader><Leader>f
nmap <Leader>t :TagbarToggle<CR>
nmap <Leader>gs :Gstatus<CR>
nmap <Leader>gd :Gdiff<CR>
nmap <Leader>gc :Gcommit<CR>
nmap <Leader>gb :Gblame<CR>
nmap <Leader>gl :Glog<CR>:copen<CR><C-w>J
nmap <Leader>gr :Gread<CR>
nmap <Leader>gw :Gwrite<CR>
nmap <Leader>gp :Git push<CR>
nmap <Leader>gg :vim //j %%**<CR>:copen<CR><C-w>J

nnoremap gp "+gp
nnoremap gP "+gP

nmap <F2> :set invpaste<CR>

nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
nnoremap & :&&<CR>

vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

imap <C-w> <Nop>
imap <C-u> <Nop>

cnoremap <expr> %% getcmdtype()==':' ? expand('%:h').'/' : '%%'

xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
	let temp = @s
	norm! gv"sy
	let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
	let @s = temp
endfunction

"for special directories.
nmap <Leader>cs :split ~/dotfiles/cheat<CR>
nmap <Leader>cv :split ~/dotfiles/cheat/vim.md<CR>
nmap <Leader>cg :split ~/dotfiles/cheat/git.md<CR>
if has('mac')
  nmap <Leader>n :Ex ~/notes<CR>
elseif has('unix')
else
  if $COMPUTERNAME == "ANTARES"
  else
    nmap <Leader>n :Ex d:\dwh\notes<CR>
  endif
endif
