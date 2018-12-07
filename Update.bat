git add *.asm *.exe Todo *.bat
set /p CommitMessage="Enter Message: "
git commit -m "%CommitMessage%"
git push origin master
pause