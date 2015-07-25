scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8,cp932,sjis,utf-16le,euc-jp
set fileformats=unix,dos,mac

"Color(overwrite macvim).
set t_Co=256
colorscheme slate

"No problem with relativenumber fog gvim.
set relativenumber

"Key map.
nmap <Leader>ge :split $HOME/dotfiles/.gvimrc<CR>
nmap <Leader>gs :so $MYGVIMRC<CR>
" autocmd bufwritepost .gvimrc source $MYGVIMRC
nmap <C-W><C-S> :<C-u>call WinSidebyside()<CR>

if ( has('win32') || has('win64') )
    set list lcs=tab:»\ ,eol:¬,trail:·
        "Don't use a character which shows in double-width.
endif

"Fonts.
if has('mac')
  set guifont=Consolas:h14
  set guifontwide=Monaco:h14
elseif has('unix')
else
  set guifont=Consolas:h11
  set guifontwide=MS_Gothic:h11
endif

"Window placement.
function! InitPlacement()
	if has('mac')
		winpos 400 0
		set lines=50 columns=100
	elseif has('unix')
	else
		if $COMPUTERNAME == "ANTARES"
			winpos 400 10
			set lines=35 columns=90
		else
			winpos 800 10
			set lines=50 columns=100
		endif
	endif
endfunction
function! SidebysidePlacement()
	if has('mac')
		winpos 150 0
		set lines=50 columns=150
	elseif has('unix')
	else
		if $COMPUTERNAME == "ANTARES"
			winpos 0 0
			set lines=35 columns=160
		else
			winpos 320 10
			set lines=50 columns=200
		endif
	endif
endfunction
function! WinSidebyside()
	call SidebysidePlacement()
	if expand('#')==''
		vsplit
	else
		vsplit #
	endif
	wincmd =
endfunction

call InitPlacement()
