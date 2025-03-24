vim9script
import autoload './functions.vim'
import autoload './messages.vim'

def ConvertMsgs(msgs: list<messages.Message>): list<dict<string>>
  var args: list<dict<string>>
  for msg in msgs
    add(args, {
      role: msg.role,
      content: msg.content,
    })
  endfor
  return args
enddef
export def ConvertFns(fns: dict<functions.Function>): list<dict<any>>
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

export def Call(ms: list<messages.Message>, fns: dict<functions.Function>): dict<any>
  const msgs = ConvertMsgs(ms)
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

