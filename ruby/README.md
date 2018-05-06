For this implementation of our jit we extended ruby with C.

In order to run the jit you'll need to compile our custom library :

- from ruby directory run  ```./c_wrapper/ruby extconf.rb ; ./c_wrapper/make```
- ```jsp | ./ruby/Jit.rb```
- enter the expression you want to compile (MUST end with a ;), then type `ctrl+D`
