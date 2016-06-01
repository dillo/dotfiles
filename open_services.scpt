tell application "iTerm"
  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "brew update"

      -- set term1 to 0
      -- repeat until (term1 = 1)
      --   if (text of current session contains "Updated") then
      --     set term1 to 1
      --   end if
      --   delay 4.0
      -- end repeat

      write text "pgrep -f [n]ginx | xargs sudo kill"
      delay 4.0
      write text "sudo nginx"

      write text "ulimit -n 10000"
      write text "pgrep -f [r]iak | xargs sudo kill"
      delay 4.0
      write text "riak start"

      write text "pgrep -f [m]ysql | xargs sudo kill"
      delay 4.0
      write text "mysql.server start"

      write text "lsof -ti tcp:25672 | xargs kill"
      delay 4.0
      write text "rabbitmq-server -detached"

      write text "cd ~/source/steve; bundle exec bin/steve_worker.rb stop"
      delay 4.0
      write text "osascript -e quit app Genymotion"
      write text "open -a Genymotion"
    end tell
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:9310 | xargs kill"
      write text "cd ~/source/confusion/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec puma -p9310"
      set name to "confusion"
    end tell

    set term1 to 0
    repeat until (term1 = 1)
      if (text of current session contains "Listening") then
        set term1 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:3000 | xargs kill"
      write text "cd ~/source/zutron/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake db:migrate; bundle exec rails s -p3000"
      set name to "zutron"
    end tell

    set term2 to 0
    repeat until (term2 = 1)
      if (text of current session contains "Listening") then
        set term2 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:9293 | xargs kill"
      write text "cd ~/source/metasaurus/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec puma -p9293"
      set name to "meta"
    end tell

    set term3 to 0
    repeat until (term3 = 1)
      if (text of current session contains "Listening") then
        set term3 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:9294 | xargs kill"
      write text "cd ~/source/leads/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec puma -p9294"
      set name to "leads"
    end tell

    set term4 to 0
    repeat until (term4 = 1)
      if (text of current session contains "Listening") then
        set term4 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:9295 | xargs kill"
      write text "cd ~/source/m.apartmentguide/; git checkout dev; git stash; git pull --rebase; bundle install; webpack; bundle exec rake confusion:migrate; npm install; bundle exec puma -p9295"
      set name to "mdotAg"
    end tell

    set term5 to 0
    repeat until (term5 = 1)
      if (text of current session contains "Listening") then
        set term5 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:4567 | xargs kill"
      write text "cd ~/source/onesearch/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec puma -p4567"
      set name to "onesearch"
    end tell

    set term6 to 0
    repeat until (term6 = 1)
      if (text of current session contains "Listening") then
        set term6 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:9301 | xargs kill"
      write text "cd ~/source/ag_mobile_api/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake confusion:migrate; bundle exec puma -p9301"
      set name to "Ag mAPI"
    end tell

    set term7 to 0
    repeat until (term7 = 1)
      if (text of current session contains "Listening") then
        set term7 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:9303 | xargs kill"
      write text "cd ~/source/mobile_api/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake confusion:migrate; bundle exec puma -p9303"
      set name to "Native mAPI"
    end tell

    set term7 to 0
    repeat until (term7 = 1)
      if (text of current session contains "Listening") then
        set term7 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:3030 | xargs kill"
      write text "cd ~/source/visits/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake db:migrate; bundle exec rails s -p3030"
      set name to "visits"
    end tell

    set term8 to 0
    repeat until (term8 = 1)
      if (text of current session contains "Listening") then
        set term8 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "lsof -ti tcp:9400 | xargs kill"
      write text "cd ~/source/steve/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake db:migrate; bundle exec rails s -p9400"
      set name to "steve"
    end tell

    set term9 to 0
    repeat until (term9 = 1)
      if (text of current session contains "Listening") then
        set term9 to 1
      end if
      delay 1.0
    end repeat
  end tell

  make new terminal

  tell the current terminal
    activate current session
    launch session "FooLegit"
    tell the last session
      write text "cd ~/source/steve/; bundle exec bin/steve_worker.rb start"
      set name to "steve-worker"
    end tell
  end tell
end tell
