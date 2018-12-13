restart -force

force d(0) "B3"
force d(1) "B4"
force s1(0) "E2"
force s1(1) "F2"
force s1(2) "G2"
force s2(0) "C8"
force s2(1) "D8"
force s2(2) "E8"
force cr(0) "E4"
force cr(1) "E5"
force cr(2) "E6"
force b(0) "G8"
force b(1) "H8"
force b(2) "I8"
force b(3) "J8"
force ca(0) "J2"
force ca(1) "J3"
force ca(2) "J4"
force ca(3) "J5"
force ca(4) "J6"

force initialize '1'
run 100
force initialize '0'
run 10

force location "B3"
force fired '1'
run 100
force fired '0'
run 100
force location "B4"
force fired '1'
run 100
force fired '0'
run 100

force location "E2"
force fired '1'
run 100
force fired '0'
run 100
force location "F2"
force fired '1'
run 100
force fired '0'
run 100
force location "G2"
force fired '1'
run 100
force fired '0'
run 100

force location "C8"
force fired '1'
run 100
force fired '0'
run 100
force location "D8"
force fired '1'
run 100
force fired '0'
run 100
force location "E8"
force fired '1'
run 100
force fired '0'
run 100

force location "E4"
force fired '1'
run 100
force fired '0'
run 100
force location "E5"
force fired '1'
run 100
force fired '0'
run 100
force location "E6"
force fired '1'
run 100
force fired '0'
run 100

force location "G8"
force fired '1'
run 100
force fired '0'
run 100
force location "H8"
force fired '1'
run 100
force fired '0'
run 100
force location "I8"
force fired '1'
run 100
force fired '0'
run 100
force location "J8"
force fired '1'
run 100
force fired '0'
run 100

force location "J2"
force fired '1'
run 100
force fired '0'
run 100
force location "J3"
force fired '1'
run 100
force fired '0'
run 100
force location "J4"
force fired '1'
run 100
force fired '0'
run 100
force location "J5"
force fired '1'
run 100
force fired '0'
run 100

force location "J6"
force fired '1'
run 100
force fired '0'
run 100