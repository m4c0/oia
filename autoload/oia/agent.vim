vim9script
import autoload "./call.vim"
import autoload "./messages.vim"

# TODO: actually call tools

def Agent(args: list<messages.Message>, tls: list<any>): string
  var msgs: list<dict<any>> = messages.Convert(args)
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

