vim9script

export class Argument
  this.type: string
  this.description: string
endclass
export class Function
  this.description: string
  this.parameters: dict<Argument>
endclass
export def Convert(fns: dict<Function>): list<dict<any>>
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

