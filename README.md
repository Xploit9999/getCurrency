### DESCRIPTION

This script displays the current value of a specified currency pair. As an example:
I need to know the exchange rate between the US Dollar and the Colombian Peso.

To find the currency codes or the code for your desired currency, 
visit: https://en.wikipedia.org/wiki/ISO_4217

### USAGE

    The command structure must be 'source currency code - target currency code.'

    -c   'Code pair from source to target code'
    -h   'Display this help panel.'

```vim
    ./getCurrency.sh -c USD-COP   
```

### IMPORTANT NOTE:

The script will write log(s) of your queries to the /tmp directory for comparison purposes. 
This allows tracking if the currency is increasing or decreasing. The output value will 
be indicated with a + or - sign, representing the gained value.

### EXAMPLE:

```vim
$ ./getCurrency.sh -c USD-COP
$ -3968.89 COP
```
