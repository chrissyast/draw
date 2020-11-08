Public site - http://santadraw.herokuapp.com

# README

This project uses a Vue frontend and a Rails API backend, in the same repository.
 
 In development, this can be handled by running 
 
 `cd back && bundle exec rails server -p 3000`
 and
 `cd front npm run serve`
 
 However, in production two different Heroku apps run the two parts.
 
 The 'front' directory is pushed to the santadraw remote and the 'back' directory is pushed to santadraw_back. There are also staging versions of both.
 
 To ease deployment, I created a series of .zshrc commands for Mac.
 Unfortunately on PC, these kind of 'nested' commands don't work in the terminal ([see here](https://stackoverflow.com/a/28904116/8940624)), so has to be run in two separate commands. 
 
 For example, instead of 
 
 ```git push heroku_back_staging `git subtree split --prefix back master`:master --force```
 
 you would have to run 
 
 `git subtree split --prefix back master`
 
 which will return an id, and then run
 
 `git push heroku_back_staging idFromStep1:master --force`
 
 Before running these, you will need to install the Heroku CLI and also configure the following remotes in git.  
 
 `git remote add heroku_back https://git.heroku.com/santadrawback.git`
 `git remote add heroku_front https://git.heroku.com/santadraw.git`
 `git remote add heroku_back_staging https://git.heroku.com/santadrawback-staging.git`
 `git remote add heroku_front_staging https://git.heroku.com/santadraw-staging.git`
 
 
 ```
# Custom branches
arguments 
$1 front/back 
$2 branch name ('' for master)
$3 staging (or leave blank for prod)
function deploy() {
  git push heroku_$1$3 `git subtree split --prefix $1 $2`:master --force
}

#master
function deploy_back() {
  git push heroku_back_staging `git subtree split --prefix back master`:master --force
}

function deploy_front() {
  git push heroku_front_staging `git subtree split --prefix front master`:master --force
}

function deploy_back_prod() {
  git push heroku_back `git subtree split --prefix back master`:master --force
}

function deploy_front_prod() {
  git push heroku_front `git subtree split --prefix front master`:master --force
}


```
