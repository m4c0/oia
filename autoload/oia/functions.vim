vim9script

export class Argument
  this.name: string
  this.type: string
  this.description: string
endclass
export class Function
  this.name: string
  this.description: string
  this.parameters: list<Argument>
endclass
export def Convert(fns: list<Function>): list<dict<any>>
  var res = []
  for fn in fns
    var params = {}
    var req = []
    for param in fn.parameters
      add(req, param.name)
      params[param.name] = {
        type: param.type,
        description: param.description,
      }
    endfor

    add(res, {
      type: "function",
      function: {
        name: fn.name,
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

