
for t in tests/*; do
  echo "==== running $t ===="
  ./ploy.py $t || break
  echo
done
