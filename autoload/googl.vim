function! googl#shorten(url) abort
  let s:apikey=get(g:, 'googl_api_key', '')
  if s:apikey == ''
    echoerr('[ERR] please set g:googl_api_key. see: https://developers.google.com/url-shortener/v1/getting_started')
    return ''
  endif
  let head = {}
  let head['Content-Type'] = 'application/json'
  let res = webapi#http#post(printf('https://www.googleapis.com/urlshortener/v1/url?key=%s', s:apikey), printf('{"longUrl": "%s"}', a:url), head, )
  let obj = webapi#json#decode(res.content)

  if has_key(obj, 'error')
    if has_key(obj['error'], 'message')
      echomsg(obj['error']['message'])
    else
      echomsg('Unknown error happened!')
    endif
    return ''
  endif
  if has_key(obj, 'id')
    return obj['id']
  else
    echomsg('Invalid response')
    return ''
  endif
endfunction
