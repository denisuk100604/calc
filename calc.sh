#!/bin/bash

operation=""
numbers=""
log_file=""

log_error() {
        if [ -n "$log_file" ]; then
                echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
        fi
        echo "$1" >&2
}

while getopts "o:n:l:" opt; do
        case $opt in
                o)
                        operation=$OPTARG ;;
                n)
                        numbers=$OPTARG ;;
                l)
                        log_file=$OPTARG ;;
        esac
done

nums=($numbers)

case $operation in
        pow) required=1 ;;
        *) required=2 ;;
esac

if [ ${#nums[@]} -lt $required ]; then
        error_msg="Ошибка: недостаточно чисел для операции $operation"
        log_error "$error_msg"
        exit 1
fi

calculate() {
        case $operation in
                sum)
                        result=$(echo "${nums[@]}" | tr ' ' '+' | bc) ;;
                sub)
                        result=$(echo "${nums[0]} - $(echo "${nums[@]:1}" | tr ' ' '-')" | bc) ;;
                mul)
                        result=$(echo "${nums[@]}" | tr ' ' '*'  | bc) ;;
                div)
                        if [[ "${nums[1]}" -eq 0 ]]; then
                                error_msg="Oшибка: деление на ноль"
                                log_error "$error_msg"
                                exit 1
                        fi
                        result=$(echo "${nums[0]} / ${nums[1]}" | bc) ;;
                pow)
                        result=$(echo "${nums[0]} ^ ${nums[1]}" | bc) ;;
                *)
                        error_msg="Неверная операция"
                        log_error "$error_msg"
                        exit 1;;
        esac
        echo "Результат: $result"
}
calculate
~
