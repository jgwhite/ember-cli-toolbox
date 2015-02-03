# USAGE:
#
# ./test-addon.sh addon-author/addon-name contributor/ember-cli#branch

repo=$1

addon=`echo $repo | awk '{ split($0, a, "/"); print a[2] }'`

if [ $2 ]; then
  branch=$2
else
  branch="ember-cli/master"
fi

 reset="\033[0m"
   red="\033[0;31m"
 green="\033[0;32m"
yellow="\033[0;33m"

echo -e "\nTesting $yellow$repo$reset against $yellow$branch$reset...\n"

echo -e "Removing $addon/...${reset}"
rm -rf $addon

echo -e "Cloning...${reset}"
git clone git@github.com:$repo > /dev/null 2>&1
cd $addon

echo -e "Installing $branch..."
npm i --save-dev $branch > /dev/null 2>&1

echo -e "Installing NPM dependencies..."
npm i > /dev/null 2>&1

echo -e "Installing Bower dependencies..."
bower i > /dev/null 2>&1

echo -e "Testing..."
npm test
result=$?

echo -e "Removing $addon/...${reset}"
rm -rf $addon

if [ "$result" -eq "0" ]; then
  echo -e "\nResult: ${green}Passed!${reset}"
else
  echo -e "\nResult: ${red}Failed!${reset}"
fi

exit $result
