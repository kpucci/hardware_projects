li $r1,0
# increment from 0 to 15
# lowest hex digit will cycle from '0' to 'F'
loop0: put $r1,0 # output current value
addi $r1,1 # increment value by 1
mov $r2,$r1 # check for loop end
addi $r2,-16 # end of loop?
bn $r2,loop0
halt
