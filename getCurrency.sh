#!/usr/bin/env bash

green='\e[32m'
red='\e[31m'
yellow='\e[33m'
endColor='\e[0m'

function help_panel(){

    printf '%100s\n' " " | tr " " "-"
    cat <<-!
    This script displays the current value of a specified currency pair. As an example:
    I need to know the exchange rate between the US Dollar and the Colombian Peso.

    To find the currency codes or the code for your desired currency, 
    visit: https://en.wikipedia.org/wiki/ISO_4217

    Usage:

        The command structure must be 'source currency code - target currency code.'

        -c   'Code pair from source to target code'
        -h   'Display this help panel.'

        ./getCurrency.sh -c USD-COP   

    Important Note:

    The script will write log(s) of your queries to the /tmp directory for comparison purposes. 
    This allows tracking if the currency is increasing or decreasing. The output value will 
    be indicated with a + or - sign, representing the gained value.

    EXAMPLE:

    $ ./getCurrency.sh -c USD-COP
    $ -3968.89 COP
!
    printf '%100s\n' " " | tr " " "-"
}

function exchange_rate(){

    read -r value < <(    
    curl -s https://www.google.com/finance/quote/${1} \
    -H 'authority: www.google.com' \
    -H 'accept: */*' \
    -H 'accept-language: en-US,en;q=0.9' \
    -H 'content-type: application/x-www-form-urlencoded;charset=UTF-8' \
    -H 'origin: https://www.google.com' \
    -H 'referer: https://www.google.com/' \
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36' \
    | grep -o "data-last-price=\"[^\"]*\""
    )

    declare -g current_value=${value:17:-1}
    declare -g log_file="/tmp/getCurrency_${1}.log"

    printf '%(%a %b %y -%l:%M %p)T [ OK ] Currency value: $%s\n' "-1" "${current_value}" >> ${log_file}
}

function currency_value(){

    declare previous_value=`awk 'END{print $NF}' ${log_file}`

    [[ ${current_value} > ${previous_value##$} ]] && { printf "${green}%s %s\n${endColor}" "+${current_value}" "${code:4}"; } \
    || { printf "${red}%s %s\n${endColor}"  "-${current_value}" "${code:4}" ; }
}

function __main__(){

    declare -i count=0
    local OPTIND

    while getopts ":c:h:" args; do
        case ${args} in 
        c) code=${OPTARG}; let count++ ;;
        h) help_panel=${OPTARG} ;;
        esac
    done

    [[ ${count} -ne 1 ]] && { printf "${yellow}";help_panel; printf "${endColor}" ; } \
    || { exchange_rate "${code}"; currency_value ; }
}

__main__ "$@"
