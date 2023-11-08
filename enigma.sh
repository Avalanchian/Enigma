#!/usr/bin/env bash

function main() {
    echo "Welcome to the Enigma!"
    while true; do
        echo "0. Exit"
        echo "1. Create a file"
        echo "2. Read a file"
        echo "3. Encrypt a file"
        echo "4. Decrypt a file"
        echo "Enter an option:"
        read -r option
        check_option='^[0-4]$'
    
        if [[ ! "$option" =~ $check_option ]]; then
            echo "Invalid option!"
            continue
        fi

        case "$option" in
            0 )
                echo "See you later!"
                return;;
            1 )
                echo "Enter the filename:"
                read -r filename
                check_filename='^[a-zA-Z\.]+$'
                if [[ ! "$filename" =~ $check_filename ]]; then
                    echo "File name can contain letters and dots only!"
                    continue
                fi
                echo "Enter a message:"
                read -r message
                check_message='^[A-Z ]+$'
                if [[ ! "$message" =~ $check_message ]]; then
                    echo "This is not a valid message!"
                    continue
                fi
                echo "$message" > "$filename"
                echo "The file was created successfully!"
                continue;;
            2 )
                echo "Enter the filename:"
                read -r filename
                if [[ $(find "$filename" | wc -c) -eq 0 ]]; then
                    echo "File not found!"
                    continue
                fi
                echo "File content:"
                cat "$filename"
                continue;;
            3 )
                echo "Enter the filename:"
                read -r filename
                if [[ $(find . -name "$filename" | wc -c) -eq 0 ]]; then
                    echo "File not found!"
                    continue
                fi
                echo "Enter password:"
                read -r password
                openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$filename" -out "${filename}.enc" -pass pass:"$password" &>/dev/null
                exit_code=$?
                if [[ $exit_code -ne 0 ]]; then
                    echo "Fail"
                    continue
                fi
                rm "$filename"
                echo "Success"
                continue;;
            4 )
                echo "Enter the filename:"
                read -r filename
                if [[ $(find . -name "$filename" | wc -c) -eq 0 ]]; then
                    echo "File not found!"
                    continue
                fi
                echo "Enter password:"
                read -r password
                openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$filename" -out "${filename%.enc}" -pass pass:"$password" &>/dev/null
                exit_code=$?
                if [[ $exit_code -ne 0 ]]; then
                    echo "Fail"
                    continue
                fi
                rm "$filename"
                echo "Success"
                continue;;
        esac
    done
}

main
