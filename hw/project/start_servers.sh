for i in "Alford" "Ball" "Hamilton" "Holiday" "Welsh"
do
  echo Starting $i
  python server.py $i &
done
echo All servers have been started