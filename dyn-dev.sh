SESH="$1"
DIR="$2"

tmux start-server

tmux has-session -t $SESH 2>/dev/null

tmux attach-session -t $SESH

if [ $? != 0 ]; then
  tmux new-session -d -s $SESH -n "nvim"

  tmux send-keys -t $SESH:nvim "cd $DIR" C-m
  tmux send-keys -t $SESH:nvim "nvim" C-m

  tmux new-window -t $SESH -n "server"
  tmux send-keys -t $SESH:server "cd $DIR" C-m
  tmux send-keys -t $SESH:server "yarn dev" C-m

  tmux new-window -t $SESH -n "repo"
  tmux send-keys -t $SESH:repo "cd $DIR" C-m

  tmux select-window -t $SESH:nvim
fi

tmux attach-session -t $SESH
