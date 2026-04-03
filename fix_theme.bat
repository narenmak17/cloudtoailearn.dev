@echo off
echo ============================================
echo  Fixing Hugo theme submodule issue
echo ============================================

cd /d "D:\PERSONAL\LEARN & GROW\Software_Learn\quickstart"

echo Step 1: Removing submodule from git index...
git rm --cached themes/awesome-hugo -r --force 2>nul
echo Done.

echo Step 2: Clearing submodule config...
git submodule deinit -f themes/awesome-hugo 2>nul
echo Done.

echo Step 3: Deleting .git gitlink file inside theme...
del /f /q "themes\awesome-hugo\.git" 2>nul
echo Done.

echo Step 4: Removing .git folder inside theme if exists...
rmdir /s /q "themes\awesome-hugo\.git" 2>nul
echo Done.

echo Step 5: Staging all theme files as regular files...
git add themes/ --force
echo Done.

echo Step 6: Staging all other changes...
git add .
echo Done.

echo Step 7: Committing...
git commit -m "fix: detach theme submodule, commit all custom layouts as regular files"
echo Done.

echo Step 8: Pushing to GitHub...
git push
echo Done.

echo ============================================
echo  All done! Check GitHub Actions tab now.
echo ============================================
pause
