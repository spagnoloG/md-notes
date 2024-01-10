# Binary patching

### In vim :)
firstly check in ghidra what hex value has function call. 
Then open binary in vim, find that and replace all fucntion hex values with 90


`:%!xxd` and `:%!xxd -r`

