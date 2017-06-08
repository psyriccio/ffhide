#!/bin/bash
gitstatus=$(git status --porcelain)
version=$(git describe --tags --always)

if ! [[ -z $gitstatus ]]; then
    version="$version""-SNAPSHOT"
fi

if [[ "$1" != "auto" ]]; then
    if ! [[ -z $gitstatus ]]; then
        printf "[1;31m%s[0m[1;37m%s[0m" "Rly?! Update version info on durty repo?" "[yes/NO]?"
        answer="no"
        read answer
        if [[ "$answer" == "yes" ]] || [[ "$answer" == "YES" ]] || [[ "$answer" == "Yes" ]]; then
            printf "[1;31m(durty state!)[0m\n[1;33mVersion update not be commited and repository tag not be updated![0m\n"
        else
            printf "%s" $answer
            exit 0
        fi
    fi
fi

short_version=$(echo "$version" | grep -oE "[^.]+\.[^.]+\.[^.]+\.[^.]+" | sed -E -e 's/(alpha|beta|gamma)//g')

sed -i -E -e 's/(\/\*VERSION_START_MARKER_TAG\*\/[[:space:]]*\")[[:print:]]*(\"\/\*VERSION_END_MARKER_TAG\*\/)/\1'"$version"'\2/g' ./src/psyriccio/ffhide/FFHide.java

#sed -i -E -e 's/(<fileVersion>[[:space:]]*)[[:print:]]*(<\/fileVersion>)/\1'"$short_version"'\2/g' ./dsrc/win/l4j.cfg.xml

#sed -i -E -e 's/(<productVersion>[[:space:]]*)[[:print:]]*(<\/productVersion>)/\1'"$short_version"'\2/g' ./dsrc/win/l4j.cfg.xml

#sed -i -E -e 's/(<txtFileVersion>[[:space:]]*)[[:print:]]*(<\/txtFileVersion>)/\1'"$version"'\2/g' ./dsrc/win/l4j.cfg.xml

#sed -i -E -e 's/(<txtProductVersion>[[:space:]]*)[[:print:]]*(<\/txtProductVersion>)/\1'"$version"'\2/g' ./dsrc/win/l4j.cfg.xml

#sed -i -E -e 's/(#define MyAppVersion \"[[:space:]]*)[[:print:]]*(\")/\1'"$version"'\2/g' ./dsrc/win/setup.iss

if [[ -z $gitstatus ]]; then
    git add src/psyriccio/ffhide/FFHide.java
    curdate=$(date +%Y%m%d_%H%M%S)
    git commit -m "version info update $curdate"
    git tag -f -m "\"$version\"" $version
fi
