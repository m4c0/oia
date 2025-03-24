vim9script
import autoload "./call.vim" as cll
import autoload "./functions.vim"
import autoload "./messages.vim"

export def Agent(msgs: list<messages.Message>, tls: dict<functions.Function>): string
  while true
    const msg = cll.Call(msgs, tls)

    if msg.content != v:null
      return msg.content
    endif

    add(msgs, msg)

    for tcall in msg['tool_calls']
      const fn = tcall.function
      const argz = json_decode(fn.arguments)
      const resp = call(targs[fn.name].Callback, [ argz ])
      add(msgs, {
        role: "tool",
        tool_call_id: tcall.id,
        content: json_encode(resp),
      })
    endfor
  endwhile
  throw 'unreachable'
enddef

