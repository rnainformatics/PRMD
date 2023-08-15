#!/usr/bin/bash
software_path=$1
cat srrid|while read id
do
$software_path/sratoolkit.2.11.0-centos_linux64/bin/prefetch $id
