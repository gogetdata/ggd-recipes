anaconda auth --create --name ANACONDA_GGD_TOKEN -o ggd-alpha --scopes 'repos api:write api:read'>token
gem install travis && travis login
travis encrypt --add ANACONDA_GGD_TOKEN=$(cat token)
