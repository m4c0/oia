vim9script

def Run()
  const key = systemlist("cat ~/.openai")[0]
  const ctype = "-H 'Content-Type: application/json'"
  const authz = $"-H 'Authorization: Bearer {key}'"
  const curl = $"curl -s {ctype} {authz} https://api.openai.com/v1/chat/completions"
  echo json_decode(system(curl))
enddef

Run()
