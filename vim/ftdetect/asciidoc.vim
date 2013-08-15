au BufRead,BufNewFile *.txt              set filetype=asciidoc

" Since 7.3 something somewhere is turning spelling on for text files, (which I
" almost never want).  When we re-detect as asciidoc it keeps the spell off.
au FileType asciidoc setlocal nospell
