set nocompatible
set spelllang=en_ca
set number
set whichwrap+=<,>,[,],h,l
set wrap linebreak

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

set pastetoggle=<F4>
set tabstop=4
set history=1000
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set shortmess=atToOI

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END



endif " has("autocmd")

set autoindent

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

nnoremap <F5> :GundoToggle<CR>
nnoremap <F6> :NERDTree %<CR>

if has ('gui_running')
  colorscheme jellybeans
  set guioptions-=T  "remove toolbar
  set guioptions-=r  "remove right-hand scroll bar
  set guifont=Terminess\ Powerline\ 8
endif

set laststatus=2

" Pathogen
call pathogen#infect()

" custom modeline
function! CustomModeLine(cid)
  let i = &modelines
  let lln = line("$")
  if i > lln | let i = lln | endif
  while i>0
    let l = getline(lln-i+1)
    if l =~ a:cid
     exec strpart(l, stridx(l, a:cid)+strlen(a:cid))
    endif
    let i = i-1
  endwhile
endfunction

au BufReadPost * :call CustomModeLine("customvim:")

let g:airline_powerline_fonts = 1

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

set backupdir=~/vim/tmp,.
set directory=~/vim/tmp,.
