tell application "iTerm2"
  tell the current window
    -- Shut down and restart webservers/databases/Testing-applications
    set newTab to (create tab with default profile)

    tell current session of newTab
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

      write text "pgrep -f [G]enymotion | xargs sudo kill"
      delay 4.0
      write text "open -a Genymotion"
    end tell

    -- Confusion
    set newTabConfusion to (create tab with default profile)

    tell current session of newTabConfusion
      write text "lsof -ti tcp:9310 | xargs kill"
      write text "cd ~/source/confusion/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec puma -p9310"
      set name to "confusion"

      set term1 to 0
      repeat until (term1 = 1)
        if (text of current session of newTabConfusion contains "Listening") then
          set term1 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Zutron
    set newTabZutron to (create tab with default profile)

    tell current session of newTabZutron
      write text "lsof -ti tcp:3000 | xargs kill"
      write text "cd ~/source/zutron/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake db:migrate; bundle exec rails s -p3000"
      set name to "zutron"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabZutron contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Metasaurus
    set newTabMeta to (create tab with default profile)

    tell current session of newTabMeta
      write text "lsof -ti tcp:9293 | xargs kill"
      write text "cd ~/source/metasaurus/; git checkout dev; git stash; git pull --rebase; bundle install;ENDECA_DEBUG=true bundle exec puma -p9293"
      set name to "meta"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabMeta contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Leads
    set newTabLeads to (create tab with default profile)

    tell current session of newTabLeads
      write text "lsof -ti tcp:9294 | xargs kill"
      write text "cd ~/source/leads/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec puma -p9294"
      set name to "leads"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabLeads contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- One Search
    set newTabOnesearch to (create tab with default profile)

    tell current session of newTabOnesearch
      write text "lsof -ti tcp:4567 | xargs kill"
      write text "cd ~/source/onesearch/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec puma -p4567"
      set name to "onesearch"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabOnesearch contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Visits
    set newTabVisits to (create tab with default profile)

    tell current session of newTabVisits
      write text "lsof -ti tcp:3030 | xargs kill"
      write text "cd ~/source/visits/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake db:migrate; bundle exec rails s -p3030"
      set name to "visits"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabVisits contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Steve
    set newTabSteve to (create tab with default profile)

    tell current session of newTabSteve
      write text "lsof -ti tcp:9400 | xargs kill"
      write text "cd ~/source/steve/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake db:migrate; bundle exec rails s -p9400"
      set name to "steve"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabSteve contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Steve Worker
    set newTabSteveWorker to (create tab with default profile)

    tell current session of newTabSteveWorker
      write text "cd ~/source/steve/; bundle exec bin/steve_worker.rb start"
      set name to "steve-worker"
    end tell

    -- Ag Mobile Api
    set newTabAgMobileApi to (create tab with default profile)

    tell current session of newTabAgMobileApi
      write text "lsof -ti tcp:9301 | xargs kill"
      write text "cd ~/source/ag_mobile_api/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake confusion:migrate; ENDECA_DEBUG=true bundle exec puma -p9301"
      set name to "Ag Mobile Api"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabAgMobileApi contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Native Mobile Api
    set newTabNativeApi to (create tab with default profile)

    tell current session of newTabNativeApi
      write text "lsof -ti tcp:9303 | xargs kill"
      write text "cd ~/source/mobile_api/; git checkout dev; git stash; git pull --rebase; bundle install; bundle exec rake confusion:migrate; ENDECA_DEBUG=true bundle exec puma -p9303"
      set name to "Native Mobile Api"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabNativeApi contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell

    -- Mdot Ag
    set newTabMdotAg to (create tab with default profile)

    tell current session of newTabMdotAg
      write text "lsof -ti tcp:9295 | xargs kill"
      write text "cd ~/source/m.apartmentguide/; git checkout dev; git stash; git pull --rebase; bundle install; webpack; bundle exec rake confusion:migrate; npm install; bundle exec puma -p9295"
      set name to "mdotAg"

      set term2 to 0
      repeat until (term2 = 1)
        if (text of current session of newTabMdotAg contains "Listening") then
          set term2 to 1
        end if
        delay 1.0
      end repeat
    end tell
  end tell
end tell
