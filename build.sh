#!/bin/bash
./gradlew clean
./gradlew mkRelease
rm -f ./ffhide.jar
cp ./$(cat ./lastbuild) ./ffhide.jar
