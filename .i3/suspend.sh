#!/bin/bash
#ensures that a closed lid causes the computer to suspend

while [ 1 ]
do
    sleep 10
    grep closed /proc/acpi/button/lid/LID0/state && sudo pm-suspend
done
