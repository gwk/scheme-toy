
for t in tests/*.scm; do
  echo "==== running $t ===="
  ./ploy.py $t || break
  echo
done
