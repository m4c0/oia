vim9script

export def Call(msgs: list<any>, tls: list<any>): dict<any>
  var ind = { 
    model: "gpt-4o-mini",
    messages: msgs,
  }
  if len(tls) > 0
    ind.tools = tls
  endif
  const key = readfile(expand("~/.openai"))[0]
  const ctype = "-H 'Content-Type: application/json'"
  const authz = $"-H 'Authorization: Bearer {key}'"
  const curl = $"curl -X POST --data-binary @- -s {ctype} {authz} https://api.openai.com/v1/chat/completions"
  const json = json_decode(system(curl, json_encode(ind)))
  if has_key(json, 'error')
    throw json.error.message
  endif

  return json.choices[0].message
enddef

