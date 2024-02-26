#!/bin/bash



type_data=$1;
number_of_lines=$2;


print_date(){
    DATE=$(date) 
    echo "Date of execution : $DATE";
    return 1;
}


command(){

    if [ "$1" = '-m' ];
    then
        echo "mem";
        return 1;
    fi

    if [ "$1" = '-c' ];
    then
        echo "cpu";
        return 1;
    fi

    message;
    exit;
}

execute_command(){
    ps -e -o pid,%cpu,%mem,command --sort=-%"$1" | head -n "$(($2 + 1))"
    return 1;
}



message(){

    echo """./system_logs.sh -h [--help]

    -m      List the 10 biggest memory consumers
    -c      List the top 10 CPU hogs
    nº      Number of lines

    ----------------------------------------------

    example
    
    ./system_logs.sh -c 20

    """
    return 1;

}




check_system(){

    option=$1;
    re='^[1-9]+$'

    if [ -z "$option" ] || [ "$option" = "-h" ] || [ "$option" = "--help" ]  ; then
        echo 0;
        return 1;
    elif [[ ! $2 =~ $re ]]
    then
        echo 0;
        return 1;
        
    else
        echo 1;
        return 1;
    fi



}


run()
{        
    
    return_check=$( check_system $1 $2 ); 
    if [[ $return_check == "0" ]];
    then
        message;
        return 0;
    fi
    
    print_date;

    set_commnad=$( command $1 );

    
    execute_command $set_commnad $2 

    return 1;

}

run $type_data $number_of_lines;
