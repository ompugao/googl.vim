if exists('g:loaded_googlvim')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

command! Googl :call <SID>shorten_url()

function! s:shorten_url()
  let url = input("URL to shorten: ")
  if url == ""
    echo "No URL provided."
    return
  endif

  let col = col('.')
  if col != 1
    let col += 1
  endif
  let row = line('.')

  let shorturl = googl#shorten(url)
  let content = webapi#http#get(url).content
  let charset = matchstr(content , 'charset=\zs.\{-}\ze".\{-}>')
  " title
  let title = iconv(matchstr(content , '<title>\zs.\{-}\ze</title>') ,
        \ charset , 'utf-8')
  let title = tweetvim#util#trim(substitute(title, '\n', '', 'g'))
  " url
  let shorturl = '> ' . title . ' ' . shorturl
  execute "normal! a".shorturl."\<esc>"
  call cursor(row, col)
  startinsert
endfunction

let g:loaded_googlvim = 1

let &cpo = s:save_cpo
unlet s:save_cpo
