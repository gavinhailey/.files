printf "\n${BLUE}%s${RESET}\n" "Updating custom plugins and themes"
cd custom/
for custom in plugins/*/ themes/*/; do
  if [ -d "$custom/.git" ]; then
     printf "${YELLOW}%s${RESET}\n" "${custom%/}"
     git -C "$custom" pull
  fi
done

