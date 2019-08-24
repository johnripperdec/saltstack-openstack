#!/bin/bash
mysql -e "select version();" &>/dev/null
	if [ "$?" = "0" ]; then
	mysql_secure_installation << EOF

	y
	{{ db_root_passwd }}
	{{ db_root_passwd }}
	y
	y
	y
	y
EOF
fi
