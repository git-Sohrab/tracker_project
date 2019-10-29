#!/bin/bash
#
# This file takes an argument that is an acceptance test in the student directory
#

rm Mop
rm Oop

./my_tracker -b tests/acceptance/student/at1.txt > Mop
./oracle.exe -b tests/acceptance/student/at1.txt > Oop
echo "at1.txt: "
diff Mop Oop

rm Mop
rm Oop
./my_tracker -b tests/acceptance/student/at2.txt > Mop
./oracle.exe -b tests/acceptance/student/at2.txt > Oop
echo "at2.txt: "
diff Mop Oop

rm Mop
rm Oop
./my_tracker -b tests/acceptance/student/at3.txt > Mop
./oracle.exe -b tests/acceptance/student/at3.txt > Oop
echo "at3.txt: "
diff Mop Oop

rm Mop
rm Oop
./my_tracker -b tests/acceptance/student/at4.txt > Mop
./oracle.exe -b tests/acceptance/student/at4.txt > Oop
echo "at4.txt: "
diff Mop Oop

rm Mop
rm Oop
./my_tracker -b tests/acceptance/student/at5.txt > Mop
./oracle.exe -b tests/acceptance/student/at5.txt > Oop
echo "at5.txt: "
diff Mop Oop

rm Mop
rm Oop
./my_tracker -b tests/acceptance/student/at6.txt > Mop
./oracle.exe -b tests/acceptance/student/at6.txt > Oop
echo "at6.txt: "
diff Mop Oop

rm Mop
rm Oop
./my_tracker -b tests/acceptance/student/at7.txt > Mop
./oracle.exe -b tests/acceptance/student/at7.txt > Oop
echo "at7.txt: "
diff Mop Oop
