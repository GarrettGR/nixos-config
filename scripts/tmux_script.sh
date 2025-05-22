#/usr/bin/env zsh

if [ -z $TMUX ] && [ -z $SKIP_TMUX ]; then
  delimiter=","
  sessions=$(tmux list-sessions -F "#{session_attached}${delimiter}#{session_id}")
  
  unused_sessions=$(echo $sessions | grep ^0)
  used_sessions=$(echo $sessions | grep ^1)

  unused_sessions_ids=$(echo $unused_sessions | cut --delimiter=$delimiter --fields=2 | sed 's/\$//')
  used_sessions_ids=$(echo $used_sessions | cut --delimiter=$delimiter --fields=2 | sed 's/\$//')
  
  sorted_unused_sessions_ids=$(echo $unused_sessions_ids | sort --numeric)
  sorted_used_sessions_ids=$(echo $used_sessions_ids | sort --numeric)

  first_unused_session_id=$(echo $sorted_unused_sessions_ids | head --lines 1)
  first_free_session_id=$(echo $sorted_used_sessions_ids | awk -v RS='\\s+' '{ a[$1] } END { for(i = 1; i in a; ++i); print i }')

  if [ -z $first_unused_session_id ]; then
    exec tmux new-session -t $first_free_session_id
  else
    exec tmux attach-session -t $first_unused_session_id
  fi
fi
