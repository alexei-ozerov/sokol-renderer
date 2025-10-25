#!/bin/bash 

echo -e "Linting core and library code."
odinfmt ./core
odinfmt ./library

exit 0
