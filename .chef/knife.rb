cookbook_path    ["cookbooks", "site-cookbooks"]
node_path        "nodes"
role_path        "roles"
environment_path "environments"
data_bag_path    "data_bags"
#encrypted_data_bag_secret "data_bag_key"
knife[:berkshelf_path] = "cookbooks"

log_level                :info
log_location             STDOUT
node_name                'kazuki.fujikawa'
client_key               '/Users/kazuki.fujikawa/repos/chef-repo/.chef/k-fujikawa.pem'
validation_client_name   'chef-validator'
validation_key           '/etc/chef-server/chef-validator.pem'
chef_server_url          'https://o-04823-mac.local:443'
syntax_check_cache_path  '/Users/kazuki.fujikawa/repos/chef-repo/.chef/syntax_check_cache'
