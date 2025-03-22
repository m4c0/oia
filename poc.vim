vim9script
import autoload "oia/call.vim"
import autoload "oia/messages.vim"
import autoload "oia/functions.vim" as fns

def Agent(margs: list<messages.Message>, targs: dict<fns.Function>): string
  var msgs: list<dict<any>> = messages.Convert(margs)
  var tls: list<dict<any>> = fns.Convert(targs)
  while true
    const msg = call.Call(msgs, tls)

    if msg.content != v:null
      return msg.content
    endif

    add(msgs, msg)

    for tcall in msg['tool_calls']
      const fn = tcall.function
      const argz = json_decode(fn.arguments)
      add(msgs, {
        role: "tool",
        tool_call_id: tcall.id,
        content: json_encode("a, b, c"),
      })
    endfor
  endwhile
  throw 'unreachable'
enddef

def AgentExample()
  echo Agent([
    messages.Dev(["You are an automated assistant robot without personality. You are dealing with a very capable human, so you don't need to explain to go into details of your reasoning."]),
    messages.User(["List files in current directory."])
  ], {
    list_files: fns.Function.new("List files in a given directory. The tool don't recurse and it only works with directories. Result is empty if directory does not exist.", {
      path: fns.Argument.new("string", "Directory to list"),
    }),
  })
enddef

AgentExample()
