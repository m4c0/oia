vim9script

export def Image(prompt: string, style: string, out: string)
  var ind = { 
    model: "dall-e-2",
    prompt: prompt,
    response_format: "b64_json",
  }
  if (len(style) > 0)
    ind.style = style # vivid or natural
  endif

  const ctype = "-H 'Content-Type: application/json'"
  const authz = $"-H 'Authorization: Bearer {g:oia_openai_token}'"
  const curl = $"curl -X POST --data-binary @- -s {ctype} {authz} https://api.openai.com/v1/images/generations"
  const json = json_decode(system(curl, json_encode(ind)))
  if has_key(json, 'error')
    throw json.error.message
  endif

  var b64 = json.data[0].b64_json
  system($'base64 -d -o {out}', b64)
enddef

