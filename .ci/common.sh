check_for_depends() {
    local needed_cmds="aws brew jq sed"

    local missing_counter=0
    for cmd in $needed_cmds; do
      if ! hash "$cmd" >/dev/null 2>&1; then
        printf "Command not found in PATH: %s\n" "$cmd" >&2
        ((missing_counter++))
      fi
    done

    if ((missing_counter > 0)); then
      printf "%d commands are missing in PATH, aborting\n" "$missing_counter" >&2
      exit 1
    fi
}
