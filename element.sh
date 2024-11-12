#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
then
CHOSEN_ELEMENT=$1
  if [[ "$CHOSEN_ELEMENT" =~ ^[0-9]+$ ]]
  then CHOSEN_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$CHOSEN_ELEMENT';")
    if [[ -n $CHOSEN_ATOMIC_NUMBER ]]
    then
    FORMATTED_CHOSEN_ATOMIC_NUMBER=$(echo $CHOSEN_ATOMIC_NUMBER | sed -E 's/ *$|^ *//g')
    #echo "chosen atomic number = $FORMATTED_CHOSEN_ATOMIC_NUMBER"
    fi
  else
    if [[ $CHOSEN_ELEMENT =~ ^[A-Z]$|^[A-Z][a-z]$ ]]
    then CHOSEN_ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$CHOSEN_ELEMENT';")
        if [[ -n $CHOSEN_ELEMENT_SYMBOL ]]
        then
        FORMATTED_CHOSEN_ELEMENT_SYMBOL=$(echo $CHOSEN_ELEMENT_SYMBOL | sed -E 's/ *$|^ *//g')
        #echo "chosen atomic symbol = $FORMATTED_CHOSEN_ELEMENT_SYMBOL"
        fi
    else
      CHOSEN_ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE name='$CHOSEN_ELEMENT';")
        if [[ -n $CHOSEN_ELEMENT_NAME ]]
        then 
        FORMATTED_CHOSEN_ELEMENT_NAME=$(echo $CHOSEN_ELEMENT_NAME | sed -E 's/ *$|^ *//g')
        #echo "chosen element name = $FORMATTED_CHOSEN_ELEMENT_NAME"
        fi
    fi
  fi

  #formatting variables for check
  #FORMATTED_CHOSEN_ATOMIC_NUMBER=$(echo $CHOSEN_ATOMIC_NUMBER | sed -E 's/ *$|^ *//g')
  #FORMATTED_CHOSEN_ELEMENT_SYMBOL=$(echo $CHOSEN_ELEMENT_SYMBOL | sed -E 's/ *$|^ *//g')
  #FORMATTED_CHOSEN_ELEMENT_NAME=$(echo $CHOSEN_ELEMENT_NAME | sed -E 's/ *$|^ *//g')

  #element check
  if [[ $CHOSEN_ELEMENT == $FORMATTED_CHOSEN_ATOMIC_NUMBER ]]
  then
    #echo "chosen atomic number exists: success"
    CHOSEN_NUMBER_ROW=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$CHOSEN_ATOMIC_NUMBER;")
    echo "$CHOSEN_NUMBER_ROW" | while read TYPE_ID BAR NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
    do echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  else 
    if [[ $CHOSEN_ELEMENT == $FORMATTED_CHOSEN_ELEMENT_SYMBOL ]]
    then 
      #echo "chosen element symbol exists: success"
      CHOSEN_SYMBOL_ROW=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$FORMATTED_CHOSEN_ELEMENT_SYMBOL';")
      echo "$CHOSEN_SYMBOL_ROW" | while read TYPE_ID BAR NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
      do echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    else
      if [[ $CHOSEN_ELEMENT == $FORMATTED_CHOSEN_ELEMENT_NAME ]]
      then 
        #echo "chosen element name exists: sucess"
        CHOSEN_NAME_ROW=$($PSQL"SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$FORMATTED_CHOSEN_ELEMENT_NAME';")
        echo "$CHOSEN_NAME_ROW" | while read TYPE_ID BAR NUMBER BAR SYMBOL BAR NAME BAR MASS BAR MELT BAR BOIL BAR TYPE
        do echo -e "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
        done
        else echo "I could not find that element in the database."
      fi
    fi
  fi
  else echo Please provide an element as an argument.
fi