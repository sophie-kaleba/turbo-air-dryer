Thomas Campistron </br>
Sophie Kaleba </br>


naive js JIT compiler developped together with @irevoire
Will undergo some heavy refactoring in the future

# JIT

## Usage c-wrapper

- ```ruby extconf.rb ; make```
- Run ```irb```, then, ```require './memory_manager'```, then ```include MemoryManager```

Else 
- from root directory, ```./c_wrapper/ruby extconf.rb ; ./c_wrapper/make```
- ```jsp | ./ruby/Jit.rb```
- enter the expression you want to compile (MUST end with a ;), then type ctrl+D
