#!/bin/bash
# if [ -f /tmp/set_env.dockerfile ]; then
#   set -a
#   source /tmp/set_env.dockerfile
#   set +a
# fi
#overwite all the nginx config files to remove cache
#find /etc/nginx/includes -type f -exec sed -i 's/expires 365d;/expires -1;/' {} +
sed -i 's/expires 365d;/expires -1;/' /etc/nginx/includes/*.conf
#comment the redirect to cache option
sed -i '/^rewrite\s\^[(]?<cache>/ s/^/#/' /etc/nginx/includes/ds-docservice.conf

sed -i 's|^command=node /var/www|command=nodemon /var/www|'  /etc/supervisor/conf.d/ds-docservice.conf
sed -i 's|^command=node /var/www|command=nodemon /var/www|'  /etc/supervisor/conf.d/ds-converter.conf