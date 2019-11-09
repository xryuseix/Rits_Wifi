require 'yaml'

data = YAML.load(open('./config/login.yml', 'r'))
p data