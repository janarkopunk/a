function warn {
  printf '\e[1;35m%s\e[m\n' "$*"
}

for rp in /home/git/*/
do
  printf '\ec'
  cd "$rp"
  git status
  warn "${rp%/}"
  read
done
