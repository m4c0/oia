vim9script
import "./call.vim"

class ChatMessage
  this.role: string
  this.content: string
endclass
def Dev(msg: string): ChatMessage
  return ChatMessage.new('developer', msg)
enddef
def User(msg: string): ChatMessage
  return ChatMessage.new('user', msg)
enddef

def Chat(msgs: list<ChatMessage>): string
  var args: list<dict<string>>
  for msg in msgs
    add(args, {
      role: msg.role,
      content: msg.content,
    })
  endfor
  return call.Call(args, []).content
enddef

def ChatExample()
  echo Chat([
    Dev("You are an automated assistant robot without personality. Follow the instructions and don't add any information unless requested. Code requests should only contain the code."),
    User("C function to calculate fibonacci."),
  ])
enddef

ChatExample()

def AgentExample()
  echo Agent([{
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
enddef
