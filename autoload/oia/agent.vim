vim9script
import autoload "./call.vim"
import autoload "./messages.vim"

# TODO: actually call tools

def Agent(margs: list<messages.Message>, targs: list<Function>): string
  var msgs: list<dict<any>> = messages.Convert(margs)
  var tls: list<dict<any>> = Convert(targs)
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

