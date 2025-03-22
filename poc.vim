vim9script
import autoload "oia/agent.vim"
import autoload "oia/call.vim" as cll
import autoload "oia/messages.vim"
import autoload "oia/functions.vim" as fns

def ListFiles(argz: dict<string>): any
  const path = argz.path
  return [$"{path}/a", $"{path}/b"]
enddef

def AgentExample()
  echo agent.Agent([
    messages.Dev(["You are an automated assistant robot without personality. You are dealing with a very capable human, so you don't need to explain to go into details of your reasoning."]),
    messages.User(["List files in current directory."])
  ], {
    list_files: fns.Fn(ListFiles, "List files in a given directory. The tool don't recurse and it only works with directories. Result is empty if directory does not exist.", {
      path: fns.Arg("string", "Directory to list"),
    }),
  })
enddef

AgentExample()
