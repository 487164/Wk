#!/bin/bash
#
# updated: 2025.10.01 (github.com/487164)
# created: 2025.10.01 (github.com/487164)
find . -type f -exec ./overwrite.sh '{}' sed -f esP-anonymyzer.dict {} ';'
