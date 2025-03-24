vim9script

export def ConvertFns(fns: dict<any>): list<dict<any>>
  var res = []
  for name in keys(fns)
    const fn = fns[name]
    var params = {}
    var req = []
    for pname in keys(fn.parameters)
      const param = fn.parameters[pname]
      add(req, pname)
      params[pname] = {
        type: param.type,
        description: param.description,
      }
    endfor

    add(res, {
      type: "function",
      function: {
        name: name,
        description: fn.description,
        strict: v:true,
        parameters: {
          type: "object",
          additionalProperties: v:false,
          required: req,
          properties: params,
        },
      },
    })
  endfor
  return res
enddef

export def Call(msgs: list<any>, fns: dict<any>): dict<any>
  const tls = ConvertFns(fns)

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

