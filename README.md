Sophie Kaleba </br>
Thomas Campistron

naive js JIT compiler developped together with @irevoire

# JIT

## Usage c-wrapper

- ```ruby extconf.rb ; make```
- Lancer ```irb```, puis, ```require './memory_manager'```, puis ```include MemoryManager```

Sinon 
- depuis la racine, ```./c_wrapper/ruby extconf.rb ; ./c_wrapper/make```
- ```jsp | ./ruby/Jit.rb```
- saisir une expression à compiler terminée d'un ;, puis ctrl+D
