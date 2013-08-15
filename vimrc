" Don't clear the autocommands so we don't get two versions every time this is
" sourced.
autocmd!

" Indenting for C programming (and similar, usually)
" set cindent
" Enable filetype-specific indenting and plugins
filetype plugin indent on

" Due to editing as root a lot.  We can use sudoedit with this provided the
" modeline is there.
set modeline

" I hate folds.
set nofoldenable

" Additional file types (automatically sources syntax/ragel
" and friends).  NOTE: this should use filetype.vim, really.
au BufRead,BufNewFile *.xxs,*.xh setfiletype xxs
au BufRead,BufNewFile TODO*      setfiletype asciidoc
au BufRead,BufNewFile *.txt      setfiletype asciidoc
au BufRead,BufNewFile *.lemon    setfiletype lemon
au BufRead,BufNewFile CREDITS,THANKS    setfiletype asciidoc
au BufRead,BufNewFile CHANGELOG  setfiletype asciidoc
au BufRead,BufNewFile README*    setfiletype asciidoc
au BufRead,BufNewFile ChangeLog  setfiletype asciidoc
au BufRead,BufNewFile INSTALL*   setfiletype asciidoc
au BufRead,BufNewFile CMakeLists.txt setfiletype cmake
" au BufRead,BufNewFile test.txt   setfiletype asciidoc-new
au BufRead,BufNewFile /var/log/syslog setfiletype syslog
au BufRead,BufNewFile /var/log/{mail,err,ken,messages} setfiletype syslog

" Semicolon means traverse the parent trees to find tags.
set tags=tags;

" Insert spaces when I press tab.
" TODO: sometimes these get nuked.  Wtf.
set expandtab
" Tabs are 2 spaces
set tabstop=2
" Each step of (auto) indent is 2 spaces.
set shiftwidth=2

" Show tabs as >>, because otherwise I mess up people's indenting.  Listchars
" is specified because otherwise it shows eol as well.  Trail is for trailing
" spaces.
set list
set listchars=tab:»·,trail:·

" Turn on line numbers
set number

" Highlight search matches (clear highlighting with :noh)
set hlsearch

" Re-read the file if it changed on disk, but not if there are still unsaved
" changes to be committed.
set autoread

" Do shell-like completion (ie, pop up a list instead of iterating all the
" matches with tab.
set wildmode=longest,list

" Enable 256 colour terminal.
" TODO: there's an environment var to test for this.
set t_Co=256

" Colours and highlighting
syntax enable
" The colours are dark on my system.
set background=dark

" Change it depending on the sub-mode
function! SetTermModeMsgColor(mode)
  if a:mode == 'i'
    imap <Ins> <Esc>l<S-R>
    highlight ModeMsg cterm=Underline ctermbg=White ctermfg=Black
  elseif a:mode == 'r'
    imap <Ins> <Esc>li
    highlight ModeMsg cterm=Underline ctermbg=DarkRed ctermfg=White
  else
    highlight ModeMsg cterm=Underline ctermbg=White ctermfg=Black
  endif
endfunction

" note: :so /usr/share/vim/vim72/syntax/hitest.vim to see all the possible
" groups and what they're currently defined to.  Also, :help colortest.vim
if has("gui_running")
  colorscheme desert
  " Set it to what my normal bg color is (otherwise it's plain black or
  " similar.
  highlight Normal guibg=grey20
else
  colorscheme pablo
  " The default highlight colour makes comment text invisible.
  highlight Visual  ctermfg=White ctermbg=DarkGrey

  highlight Search  cterm=Underline ctermfg=Black ctermbg=Green
  " Note: this also looks ok for search.
  "highlight Search cterm=Underline ctermfg=Black ctermbg=Yellow

  highlight Todo       ctermfg=DarkRed ctermbg=Yellow
  highlight SpellBad   ctermfg=Black   ctermbg=Red
  highlight SpellLocal ctermfg=Black   ctermbg=Cyan

  " Give the mode message a different color in replace mode so I can tell
  " when I've accidentally pressed insert twice.
  au InsertEnter * call SetTermModeMsgColor(v:insertmode)
end

" Make line numbers dark.
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE
highlight LineNr gui=NONE guifg=DarkGrey guibg=NONE

" EnhancedCommentify stuff
let EnhCommentifyPretty = "yes"
let EnhCommentifyUserBindings = "yes"
let EnhCommentifyRespectIndent = "yes"
let EnhCommentifyUseBlockIndent = "yes"

" The MyEnhancedCommentify bit is needed because the normal nmap just
" calls EnhancedCommentify() <count> times, thus UseBlockIndent can't
" work.
nmap <Leader>c :MyEnhancedCommentify<CR>
vmap <Leader>c <Plug>VisualTraditional
command! -range MyEnhancedCommentify
\ call EnhancedCommentify('', 'guess', <line1>, <line2>)

" Because I get confused between insert and command mode otherwise!
noremap <Delete> <Nop>

" Because I forget to stop pressing shift all the time
map :W :w

" Find a tag under cursor.
map ,, <C-]>
" Go back in the tag stack.
map ,b <C-T>

" Make ctrl-n be `next jump position' because I'm about to remap ctrl+i :)
" Ctrl+O is previous jump.
noremap <C-N> <C-I>

" Make indent/deindent work in v and i mode.
noremap <C-I> >0
noremap <C-D> <LT>0
" also use tab/shifttab to do it.
noremap <Tab>   >0
noremap <S-Tab> <0

" Switch to insert mode if in normal mode and moving to insert-expand mode.
" This is where we do auto-completion.
nnoremap <C-X> <Ins><C-X>

" For auto-complete, show a menu (even for one match), and preview the change.
set completeopt=menuone,preview

" Use tab/shift-tab in insert mode to indent and de-indent.  The default is
" ctrl+I/D.
" inoremap <Tab>   <Esc>>><Ins>
" inoremap <S-Tab> <Esc><LT><LT><Ins>

" Define a callback to do something when commentify doesn't know what the
" comment is.
function! EnhCommentifyCallback(ft)
  if a:ft == 'latex'
    let b:ECcommentOpen = '%'
    let b:ECcommentClose = ''
  elseif a:ft == 'cmake' || a:ft == 'ragel' || a:ft == "puppet"
    let b:ECcommentOpen = '#'
    let b:ECcommentClose = ''
  elseif a:ft == 'lemon'
    let b:ECcommentOpen = '//'
    let b:ECcommentClose = ''
  elseif a:ft == 'docbk'
    let b:ECcommentOpen = '<!--'
    " Don't know why you need this, but it fails otherwise.
    let b:ECcommentMiddle = ''
    let b:ECcommentClose = '-->'
  endif
endfunction
" Tell the plugin there is one!
let g:EnhCommentifyCallbackExists = 'Yes'

" Set up for auto-wrapping with formatoptions.
set textwidth=80
" FIXME: fucks sake... this is being set for everything!!
autocmd FileType xml,tex,docbk setlocal textwidth=120

" C commenting:
"
" :0 = indent a case label zero characters (i.e keep it indented to the position
"      of the switch token)
" (s = use shiftwidth to indent after an unclosed parenthesis
" U1 = do (s even if the open bracket is the first char on the line
" Ws = use shitwidth when indenting a line after unclosed paren if the line is
"      long
" m1 = de-indent a closing parenthesis on an empty line
" h0 = don't indent after an access modifier (public/private etc)
set cinoptions=:0,(s,U1,Ws,m1,h0

" Default format options:
"
" c = auto-wrap comments using textwidth.
" r = auto-insert the comment char(s) when you press enter after a comment.
" o (missing) = don't insert a comment with the insert line o or O.
" q = 'Allow formatting of comments with the "gq" command'
" n = recognise numbered lists and wrap.
" l = don't break lines which are already too long.
set formatoptions=crqnl
" In text, always break lines (I think latex-suite pretty much always overrides
" this... meh).
autocmd FileType text,tex,latex set formatoptions=crqn

" This is for shell, so double brackets don't show up as errors.
let g:is_posix=1
" Load doxygen syntax where possible.
let g:load_doxygen_syntax=1

" Turn on spell checking if we're in a text file.  Use "ctrl+x s" in insert mode
" to get a list of suggestions.  Or :set mousemodel=popup for a popup suggestion
" list in the gui.
autocmd FileType text  set spelllang=en_gb
autocmd FileType text  set spell

" Haskell bits.
" let g:hs_highlight_delimiters = 1
let g:hs_highlight_more_types = 1

" TODO: get rid of comments when joining lines.
" http://vim.wikia.com/wiki/Remap_join_to_merge_comment_lines

" We don't like whitesapce and the end of files or end of lines.
function! RemoveTrailingWhitespace()
  let save_cursor = getpos(".")
  call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
  :%s@\($\n\s*\)\+\%$@@e
  call setpos('.', save_cursor)
endfunction

" Remove trailing whitespace from files that shouldn't have them
" Complicated formulation to avoid writing over the substitution
" history.
autocmd FileType python,docbk,xxs,c,cpp,java,ruby,cmake,latex,lemon,tex,asciidoc,sh,vim,haskell,php,puppet,javascript,htmldjango,rst
      \ autocmd BufWritePre <buffer>
      \ call RemoveTrailingWhitespace()

" call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))

" This is for solariffic, really, but 4 spaces seems to be what's "done" in
" python anyway.
autocmd FileType python setlocal sw=4
autocmd FileType python setlocal ts=4

" XML turns off spell checking in unless folding is on.  I have *no* idea why
" thsi is but this line fixes it.
let g:xml_syntax_folding=1

" FIXME:
"   this lot doesn't work.  Maybe it needs to be in the syntax/ directory?  I
"   have trouble working out why though...
au FileType docbk if 'xml' == b:docbk_type
au FileType docbk   syn cluster xmlRegionHook add=@Spell
au FileType docbk elseif 'sgml' == b:docbk_type
au FileType docbk   syn cluster sgmlRegionHook add=@Spell
au FileType docbk end

" Attempts to stop these filetypes from cocking up my other buffers.
au FileType htmldjango setlocal shiftwidth=2
au FileType javascript setlocal shiftwidth=2
au FileType javascript setlocal tabstop=2
au FileType javascript setlocal expandtab

" The highligher is not capable of doing <script> slements properly unless we
" parse the entire document.
au FileType html,htmldjango syn sync fromstart

" For dfebugging syntax files -- prints the group at cursor.
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
      \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
      \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
