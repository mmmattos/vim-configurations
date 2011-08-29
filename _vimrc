filetype off

if ! has('win16') || has('win32') || has('win64') || has('win95')
    let &runtimepath.=',~/vimfiles'
endif

call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
syntax on
filetype plugin indent on

set nocompatible
source $VIMRUNTIME/vimrc_example.vim

if has('win16') || has('win32') || has('win64') || has('win95')
    source $VIMRUNTIME/mswin.vim
    behave mswin
endif

set number
set ignorecase
set nowrap
"set beautify
"set term=builtin_ansi

"Setting up tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
set tabpagemax=20
set showtabline=4
set smarttab
set autoindent
set smartindent
set expandtab

"Setting my window preferences
"set lines=51
"set columns=120
"set guifont=Monaco
if has("gui_running")
  if has('win16') || has('win32') || has('win64') || has('win95')
    set guifont=Consolas:h12:cANSI
  elseif has("gui_gtk2")
        set guifont=DejaVu\ Sans\ Mono\ 12
  elseif has("gui_photon")
    set guifont=DejaVu\ Sans\ Mono:s12
  elseif has("gui_kde")
    set guifont=Courier\ New/11/-1/5/50/0/0/0/1/0
  elseif has("x11")
    set guifont=-*-courier-medium-r-normal-*-*-180-*-*-m-*-*
  else
    set guifont=Courier_New:h11:cDEFAULT
  endif
endif

if has('win16') || has('win32') || has('win64') || has('win95')
    set backupdir=$HOME\\_vimbackups
    set directory=$HOME\\_vimbackups
else
    set backupdir=$HOME/_vimbackups
    set directory=$HOME/_vimbackups
endif

winpos 0 0

"colorscheme
colorscheme vividchalk "blackboardblack

"indent on
filetype indent on
filetype plugin on

"added support for other file types 
autocmd bufnewfile,bufread *.json set ft=javascript

"change file type for ruby
autocmd filetype ruby set ft=ruby.ruby-rails.ruby-rspec.ruby-rails-rjs.ruby-shoulda

"change tabs to 2 space on ruby files
autocmd filetype ruby set tabstop=2
autocmd filetype ruby set shiftwidth=2
autocmd filetype ruby set softtabstop=2

"set noexpandtab to makefiles, to use <tab> char instead of spaces
autocmd filetype make setlocal noexpandtab

"set smartindent for python files
autocmd filetype python set smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class

"map to execute python files
autocmd filetype python map <leader>p :!python % <cr>

"settings for mark badwhitespaces in python files
autocmd filetype python highlight badwhitespace ctermbg=red guibg=red
autocmd filetype python match badwhitespace /^\t\+/
autocmd filetype python match badwhitespace /\s\+$/

"pylint
autocmd filetype python compiler pylint
"to disable calling pylint every time a buffer is saved put into .vimrc file
"let g:pylint_onwrite = 0
"displaying code rate calculated by pylint can be avoided by setting
"let g:pylint_show_rate = 0
"openning of quickfix window can be disabled with
"let g:pylint_cwindow = 0
"of course, standard :make command can be used as in case

"using django and python file type instead of just python
autocmd filetype python set ft=python.django

"setting file type to htmldjango and html
autocmd filetype htmldjango set ft=htmljinja.htmldjango.html
autocmd filetype html set ft=htmljinja.htmldjango.html
autocmd filetype xhtml set ft=htmljinja.htmldjango.html

"setting syntax to htmldjango and html
autocmd filetype htmldjango set syntax=htmljinja
autocmd filetype html set syntax=htmljinja
autocmd filetype xhtml set syntax=htmljinja

"setting file type to php and html (snippets)
autocmd filetype php set ft=php.html

"setting file type to eruby and html (snippets)
autocmd filetype eruby set ft=eruby.eruby-rails.html

nmap <silent> <c-p> :nerdtreetoggle<cr>
nmap <silent> <c-a> :nerdtree<cr>
nmap ,t :tabnew<cr>
nmap <c-tab> gt
nmap <c-s-tab> gt
nmap <c-t> :commandt<cr>

"Related files, useful in django
"open files related to a django project or app, as views.py, models.py or settings.py
let g:last_relative_dir = ''
nnoremap \1 :call relatedfile ("models.py")<cr>
nnoremap \2 :call relatedfile ("views.py")<cr>
nnoremap \3 :call relatedfile ("urls.py")<cr>
nnoremap \4 :call relatedfile ("admin.py")<cr>
nnoremap \5 :call relatedfile ("tests.py")<cr>
nnoremap \6 :call relatedfile ( "templates/" )<cr>
nnoremap \7 :call relatedfile ( "templatetags/" )<cr>
nnoremap \8 :call relatedfile ( "management/" )<cr>
nnoremap \9 :e urls.py<cr>
nnoremap \0 :e settings.py<cr>

"function used to open relatedfile
fun! Relatedfile(file)
    "this is to check that the directory looks djangoish
    if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
        exec "edit %:h/" . a:file
        let g:last_relative_dir = expand("%:h") . '/'
        return ''
    endif
    if g:last_relative_dir != ''
        exec "edit " . g:last_relative_dir . a:file
        return ''
    endif
    echo "Cant determine where relative file is : " . a:file
    return ''
endfun

fun SetAppDir()
    if filereadable(expand("%:h"). '/models.py') || isdirectory(expand("%:h") . "/templatetags/")
        let g:last_relative_dir = expand("%:h") . '/'
        return ''
    endif
endfun

autocmd BufEnter *.py call SetAppDir()

"Surrounds for Django templates
autocmd FileType htmldjango let g:surround_{char2nr("b")} = "{% block\1 \r..*\r &\1%}\r{% endblock %}"
autocmd FileType htmldjango let g:surround_{char2nr("i")} = "{% if\1 \r..*\r &\1%}\r{% endif %}"
autocmd FileType htmldjango let g:surround_{char2nr("w")} = "{% with\1 \r..*\r &\1%}\r{% endwith %}"
autocmd FileType htmldjango let g:surround_{char2nr("c")} = "{% comment\1 \r..*\r &\1%}\r{% endcomment %}"
autocmd FileType htmldjango let g:surround_{char2nr("f")} = "{% for\1 \r..*\r &\1%}\r{% endfor %}"

"Vala options
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead,BufNewFile *.vala            setfiletype vala
au BufRead,BufNewFile *.vapi            setfiletype vala

" Disable valadoc syntax highlight
let vala_ignore_valadoc = 1

" Enable comment strings
let vala_comment_strings = 1

" Highlight space errors
let vala_space_errors = 1

" Disable trailing space errors
"let vala_no_trail_space_error = 1
" Disable space-tab-space errors
let vala_no_tab_space_error = 1

" Minimum lines used for comment syncing (default 50)
"let vala_minlines = 120

"Indent on
filetype indent on
filetype plugin on

"pydiction
let g:pydiction_location="$HOME/vimfiles/ftplugin/pydiction/complete-dict"

"Increase HTML indent
let g:html_indent_inctags="html,head,body,tbody"

"Markdown syntax
autocmd BufRead,BufNewFile *.mkd setfiletype markdown
autocmd BufRead,BufNewFile *.markdown setfiletype markdown
autocmd BufRead,BufNewFile *.md setfiletype markdown

"Cucumber syntax
autocmd BufRead,BufNewFile *.feature setfiletype cucumber

"Change dir to the one of the current file
autocmd BufEnter * if expand("%:p:h") !~ '^/tmp' | lcd %:p:h | endif

"Make NERDTree to start from my HOME dir or the file´s dir.
autocmd VimEnter * NERDTreeToggle

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction


