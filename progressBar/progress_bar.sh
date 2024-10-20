#!/bin/bash

# Defining the width of the progress bar
WIDTH_PROGRESS_BAR=50

# Function that displays the usage of the script
usage(){
    echo "Usage: $0 [TIME_BETWEEN_UPDATES]"
    echo
    echo "This script displays a dynamic progress bar accompanied by logs."
    echo
    echo "Parameters:"
    echo "  TIME_BETWEEN_UPDATES   Time (in seconds) between each progress bar update."
    echo
    echo "Example:"
    echo "  $0 0.1"
    echo "  This will run the script with progress bar updates every 0.1 seconds."
    echo
    exit 1
}

# Function to check the inputs provided by the user
check_inputs(){
    # Checks if the argument is "-h" or "--help" and displays the usage
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        usage
        exit 1
    fi

    # Checks if the number of arguments is not equal to 1
    if [ "$#" -ne 1 ]; then
        echo "Error: Invalid number of arguments."
        usage
        exit 1
    fi

    # Checks if the argument is a valid number
    if ! [[ $1 =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Error: TIME_BETWEEN_UPDATES must be a valid number."
        usage
        exit 1
    fi
}

# Function that sets the progress rate value
set_values(){
    progressRate=$(echo "100 / $WIDTH_PROGRESS_BAR" | bc)
}

# Function that prints the progress bar
progressBar(){
    local atualProgress=$1
    printf "\rProgress: [%-${WIDTH_PROGRESS_BAR}s] %d%%" $(printf '=%.0s' $(seq 1 $(($atualProgress/$progressRate)))) $atualProgress
}

# Function to run the progress and print the log
run() {
    check_inputs $@  # Validate the inputs provided

    set_values  # Set the progress rate value

    # Loop through the progress from 1 to 100
    for i in {1..100}; do
        echo "Log message: Running progress $i"  # Log message
        progressBar $i  # Update the progress bar
        sleep $1  # Wait the defined time between steps
        echo -ne "\033[A"  # Move the cursor back to the previous line (over the log)
    done

    echo -e "\nCompleted"  # Print 'Completed' when done
}

# Run the script with the provided arguments
run $@
