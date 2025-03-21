vim9script

def Run(msgs: list<any>, tls: list<any>): string
  var ind = { 
    model: "gpt-4o-mini",
    messages: msgs,
  }
  if len(tls) > 0
    ind.tools = tls
  endif
  const key = systemlist("cat ~/.openai")[0]
  const ctype = "-H 'Content-Type: application/json'"
  const authz = $"-H 'Authorization: Bearer {key}'"
  const curl = $"curl -X POST --data-binary @- -s {ctype} {authz} https://api.openai.com/v1/chat/completions"
  const json = json_decode(system(curl, json_encode(ind)))
  if has_key(json, 'error')
    throw json.error.message
  endif

  const choice = json.choices[0]
  const msg = choice.message

  if msg.content != v:null
    return msg.content
  endif

  echom json
  throw 'unexpected result'
enddef

echo Run([{
  role: "developer",
  content: "You are an automated assistant robot without personality. You are dealing with a very capable human, so you don't need to explain to go into details of your reasoning."
}, {
  role: "user",
  content: "List files in current directory."
}], [{
  type: "function",
  function: {
    name: "list_files",
    description: "List files in a given directory. The tool don't recurse and it only works with directories. Result is empty if directory does not exist.",
    strict: v:true,
    parameters: {
      type: "object",
      required: [ "path" ],
      additionalProperties: v:false,
      properties: {
        path: {
          type: "string",
          description: "Directory to list",
        }
      },
    }
  },
}])
