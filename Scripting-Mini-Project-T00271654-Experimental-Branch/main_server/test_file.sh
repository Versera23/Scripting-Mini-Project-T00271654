x=0
base_ID="IT00"

while [ $x -le 3 ];
do
  randNum=$(shuf -i 1-9 -n 1)
  base_ID+=$randNum
  (( x++ ))
done

echo $base_ID