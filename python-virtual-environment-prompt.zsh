export VIRTUAL_ENV_DISABLE_PROMPT=1
function python_venv_info() {
  [[ -n "$VIRTUAL_ENV" ]] && echo "(`basename $VIRTUAL_ENV`) "
}