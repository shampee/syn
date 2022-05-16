# Package

version       = "0.1.0"
author        = "Hampus O"
description   = "Query moby-thesaurus.org from the command line"
license       = "MIT"
srcDir        = "src"
bin           = @["syn"]


# Dependencies

requires "nim >= 1.4.8"

task small, "Build a small stripped version":
  exec "nimble build -d:release --opt:size --passL:-s"
