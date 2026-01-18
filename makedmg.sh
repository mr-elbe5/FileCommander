#!/bin/bash

name=FileCommander
buildFolder=$1

mkdir ./dmg
rm -R ./dmg/*
rm ./$name.dmg
cp -R $buildFolder/Products/Debug/$name.app ./dmg/
hdiutil create -srcFolder ./dmg -o ./$name.dmg