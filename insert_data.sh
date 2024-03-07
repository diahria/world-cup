#!/bin/bash

if [[ $1 == "test" ]]; then
    PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
    PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi


echo "$($PSQL 'TRUNCATE TABLE games, teams')"

while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
    if [[ "$winner" != "winner"  &&  "$opponent" != "opponent" ]]; then
    $PSQL "INSERT INTO teams (name) VALUES ('$winner') ON CONFLICT DO NOTHING;"
    $PSQL "INSERT INTO teams (name) VALUES ('$opponent') ON CONFLICT DO NOTHING;"
    fi
done < "games.csv"
while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
if [[ "$year" != "year" ]];then
winner_id=$($PSQL "select team_id from teams where name='$winner'")
opponent_id=$($PSQL "select team_id from teams where name='$opponent'")
$PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values('$year','$round','$winner_id','$opponent_id','$winner_goals','$opponent_goals')"
fi
done < "games.csv"

# Do not change code above this line. Use the PSQL variable above to query your database.
