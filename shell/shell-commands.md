Run programs
-------------------------

Run with `no-hangup`. Prevent the command from being aborted when exiting the shell.  
Run in background and return command prompt to user with `&` at the end.  
Create an executable shell script with the following 3 commands.  

    curl -X POST http://localhost:8080/myapp/shutdown &
    sleep 5
    nohup java -server -Xms1G -Xmx1G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=20 -XX:ConcGCThreads=5 -XX:InitiatingHeapOccupancyPercent=70 -jar myapp-1.0-SNAPSHOT.jar > /dev/null 2>&1 &

    # or output to file

    nohup java -server -Xms1G -Xmx1G -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:ParallelGCThreads=20 -XX:ConcGCThreads=5 -XX:InitiatingHeapOccupancyPercent=70 -jar myapp-1.0-SNAPSHOT.jar > applog.log 2>&1 &


Nohup the script and keep output to nohup.out file instead of /dev/null

    nohup ./shell-script.sh 2>&1 &

Output to specific file

    nohup ./shell-script.sh > applog.log 2>&1 &

Output to file and stdout

    program [arguments...] 2>&1 | tee -a outfile



Mount/unmount ISO files
------------------------------

    fuseiso Solus-3-Budgie.iso ~/Temp/mnt/
    fusermount -u ~/Temp/mnt/



CLI search
------------------------------

    find . -iname '*jar'

    grep -inr 'solus' Dropbox/
    grep 'qt' /var/log/apt/history.log


Find the number of files in a directory.  
`find . -type f` finds all files ( -type f ) in this ( . ) directory and in all sub directories. The filenames are then printed to standard out one per line.  
This is then piped | into wc (word count) the -l option tells wc to only count lines of its input.

    find . -type f | wc -l



init.d service commands
-------------------------------

Create file

    vim /etc/init.d/service-file-name

Make it executable

    sudo chmod 755 /etc/init.d/service-file-name

Add service: configure your operating system to run it on boot.

    sudo update-rc.d service-file-name defaults     # Ubuntu
    sudo chkconfig --add service-file-name          # Red Hat & co.

Remove service

    sudo update-rc.d -f service-file-name remove



Git commands
----------------------------

### Ignore files

Make Git forget about a file that was tracked, but is now in `.gitignore`.  
E.g. .idea, .vscode, Eclipse project files.  
This will delete the `.idea` folder on pull for another user.  

    echo ".idea" >> .gitignore
    git rm -r --cached .
    git add .
    git commit -m "ignore .idea"
    git push

Another way is to delete the unwanted file, add it to `.gitignore` and commit.  
Same effect as above, but it also deletes the local file.  

Next method is independent of `.gitignore`. Git pretends the file is always up to date.  
Use for tracked files that you don't want to commit anymore.  
The file will remain on the server.  
You will get a merge conflict upon pull from remote if someone else pushed changes to the file.  

    git update-index --skip-worktree file


### Make a branch track a remote branch

    git checkout -b foobranch
    git remote add upstream https://github.com/username/hello-world.git
    git fetch upstream master
    git branch -u upstream/master
    # or
    git branch --set-upstream-to=upstream/master


### Squash commits

Make 3 local commits as example then rebase (default is `--mixed`)

    git reset HEAD~3

Now you can make one commit

    git add .
    git commit -m "relevant message for the three commits"

Or turn into 2 larger commits

    git add file1 file2
    git commit -m "first new commit"
    git add file3 file4 file5
    git commit -m "second new commit"


### Undo a git reset

Show the log of all ref updates (e.g. checkout, reset, commit, merge)

    git reflog

Reset to desired point, where `n` is a number

    git reset HEAD@{n}
