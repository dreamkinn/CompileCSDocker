#!/bin/bash

if [ "$#" -eq 0 ] || [ "$#" -ne 1 ]; then
    echo -e "\e[31m[!] Please provide an URL or tool name.\e[0m"
    echo -e "\e[32mUsage :\e[0m"
    echo -e "\e[32mcsb -l                    Print all tools\e[0m"
    echo -e "\e[32mcsb SharpHound           Try to compile known tool\e[0m"
    echo -e "\e[32mcsb https://git/tool.git  Try to compile unknown tool\e[0m"
    exit
fi

if [ "$1" == "-l" ]; then
    cat tools.txt
    exit
fi

url="$1"
re_url='(https?)://*'
if [[ ! $1 =~ $re_url ]]; then
    while IFS= read -r line; do
        tool=`echo $line | awk '{print $1}'`
        if [[ "$1" == $tool ]]; then
            url=`echo $line | awk '{print $2}'`
            echo -e "\e[32m[+] Found tool $1 at $url\e[0m"
            break
        fi
    done < tools.txt
fi

cd /data

# Clone the repository
repo_name=$(basename $url .git)
if [ -d "$repo_name" ]; then
    echo -e "\033[38;5;208m[+] Skipping cloning, $repo_name already exists\033[0m"
else
    echo -e "\e[32m[+] Cloning in $repo_name\e[0m"
    git clone $url || exit 1
fi

cd $repo_name

# Find the .sln file
sln_try=$(find . -name "*.sln" | wc -l)
if [ $sln_try -eq 0 ]; then
    echo -e "\e[31m[!] No .sln file found, trying 'the technique of the sauvage'\e[0m"
    if [ -f "$repo_name.cs" ]; then
        echo -e "\e[32m[+] Found $repo_name.cs, trying to compile with csc...\e[0m"
        csc $repo_name.cs && echo -e "\e[32m[+] Compilation successful\e[0m" && exit 0
        exit 1
    elif [ -f "Program.cs" ]; then
        echo -e "\e[32m[+] Found Program.cs, trying to compile with csc...\e[0m"
        csc Program.cs && echo -e "\e[32m[+] Compilation successful\e[0m" && exit 0
        exit 1
    else
        echo -e "\e[31m[!] No $repo_name.cs or Program.cs file found\e[0m" && exit 0
        exit 1
    fi
fi


sln_build() {
    sln_path="$1"
    repo_name="$2"

    if [ -n "$sln_path" ]; then
        sln_file=$(basename $sln_path)
    fi

    echo -e "\e[32m[+] Found $sln_path, attempting build...\e[0m"

    # Run nuget restore 
    echo -e "\e[32m[+] Running nuget restore for packages\e[0m"
    if nuget restore "$sln_path" 1>/dev/null; then
        echo -e "\e[32m[+] NuGet restore successful\e[0m"
    else
        echo -e "\e[31m[!] Error occurred during NuGet restore\e[0m"
        return
    fi

    cd /data/$repo_name

    # If there is a .sln file, go to the directory, run nuget restore, and then run msbuild giving the path to sln file
    if [ -n "$sln_file" ]; then
        if msbuild $sln_path -t:Rebuild -p:Configuration=Release -verbosity:quiet; then
            echo -e "\e[32m[+] Compilation successful\e[0m"
        else
            echo -e "\e[31m[!] Compilation failed\e[0m"     
            return
        fi
    fi
}

# Get all .sln and build
readarray -d '' array < <(find . -name "*.sln" -print0)

for i in ${array[@]}; do 
    sln_build $i $repo_name 
    ret+=$((ret + $?))
done
