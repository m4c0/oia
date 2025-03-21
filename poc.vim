vim9script

def Run(in: dict<any>): string
  const instr = json_encode(in)
  const key = systemlist("cat ~/.openai")[0]
  const ctype = "-H 'Content-Type: application/json'"
  const authz = $"-H 'Authorization: Bearer {key}'"
  const curl = $"curl -X POST --data-binary @- -s {ctype} {authz} https://api.openai.com/v1/chat/completions"
  const json = json_decode(system(curl, instr))
  if has_key(json, 'error')
    throw json.error.message
  endif

  const choice = json.choices[0]
  const msg = choice.message

  if has_key(msg, 'content')
    return msg.content
  endif

  echo json
  throw 'unexpected result'
enddef

echo Run({
  model: "gpt-4o-mini",
  messages: [{
    role: "developer",
    content: "You are an automated assistant robot without personality. You are dealing with a very capable human, so you don't need to explain to go into details of your reasoning."
  }, {
    role: "user",
    content: "List files."
  }]
})
