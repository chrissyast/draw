# README

This project uses a Vue frontend and a Rails API backend, in the same repository.
 
 In development, this can be handled by running 
 
 `cd back && bundle exec rails server -p 3000`
 and
 `cd front npm run serve`
 
 However, in production two different Heroku apps run the two parts.
 
 The 'front' directory is pushed to the santadraw remote and the 'back' directory is pushed to santadraw_back. There are also staging versions of both.
 
 To ease deployment, I created a series of .zshrc commands 
 
 ```
# Custom branches
arguments 
$1 front/back 
$2 branch name ('' for master)
$3 staging (or leave blank for prod)
# Cannot currently support 
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