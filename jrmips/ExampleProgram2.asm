.data
a: 10
b: 0
.text
la $r1,a
lw $r2,$r1
loop: add $r3,$r2
addi $r2,-1
bp $r2,loop
la $r1,b
sw $r3,$r1
lw $r4,$r1
put $r4,0 # answer should be 0x37
halt
