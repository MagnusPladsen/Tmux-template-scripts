SESH="$1" # first parameter, Tmux session name
DIR="$2" # second parameter, repository/project folder

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

if [ -z "$1" ]
  then
    echo "No tmux session name supplied"
fi

if [ -z "$2" ]
  then
    echo "No directory path supplied"
fi

tmux start-server # start tmux server if not already running

tmux has-session -t $SESH 2>/dev/null # check if session is already running

tmux attach-session -t $SESH # attach session

if [ $? != 0 ]; then # if no tmux session with same session name is running, create new
  tmux new-session -d -s $SESH -n "editor" # first window for editor

  tmux send-keys -t $SESH:editor "cd $DIR" C-m
  tmux send-keys -t $SESH:editor "nvim" C-m # or "code ." "cursor ." etc.

  tmux new-window -t $SESH -n "server" # second window for running server
  tmux send-keys -t $SESH:server "cd $DIR" C-m
  tmux send-keys -t $SESH:server "yarn dev" C-m # or "npm dev" etc

  tmux new-window -t $SESH -n "project" # third window for opening up repository/project folder
  tmux send-keys -t $SESH:project "cd $DIR" C-m

  tmux select-window -t $SESH:editor # start in editor window
fi

tmux attach-session -t $SESH

# running example:
# ./frontend-dev-template.sh "Frontend_Session" "~/git/project"
