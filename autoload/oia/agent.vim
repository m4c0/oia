vim9script
import autoload "./call.vim" as cll

export def Agent(msgs: list<any>, tls: dict<any>): string
  while true
    const msg = cll.Call(msgs, tls)

    if msg.content != v:null
      return msg.content
    endif

    add(msgs, msg)

    for tcall in msg['tool_calls']
      const fn = tcall.function
      const argz = json_decode(fn.arguments)
      const resp = call(tls[fn.name].callback, [ argz ])
      add(msgs, {
        role: "tool",
        tool_call_id: tcall.id,
        content: json_encode(resp),
      })
    endfor
  endwhile
  throw 'unreachable'
enddef

