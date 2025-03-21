vim9script
import "./chat.vim"

def ChatExample()
  echo chat.Chat([
    chat.Dev("You are an automated assistant robot without personality. Follow the instructions and don't add any information unless requested. Code requests should only contain the code. Respond with no formatting."),
    chat.User("Pascal function to calculate fibonacci"),
  ])
enddef
def ChatExample2()
  echo chat.Chat([
    chat.Dev("You are an automated assistant robot without personality. Follow the instructions and don't add any information unless requested. Code requests should only contain the code. Respond with no formatting."),
    chat.User("Rewrite this to add a new scope named XYZ"),
    chat.User("@TestValue(Scope.ABC)"),
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
