server {
    listen 80;
    server_name site.ru;

    root /var/www/site.ru/DOC_ROOT;
    index index.php index.html;

    access_log /var/www/site.ru/logs/access.log;
    error_log /var/www/site.ru/logs/error.log;

    location ~* \.(jpg|jpeg|gif|png|css|js|ico|xml|html)$ {
        expires max;
        try_files $uri =404;
    }

    location / {
        proxy_pass http://127.0.0.1:81;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    location @fallback {
        proxy_pass http://127.0.0.1:81;
    }

    location /phpmyadmin {
        alias /var/www/site.ru/DOC_ROOT/phpmyadmin;  # Используем alias вместо root
        index index.php index.html;

        # Настройка для PHP файлов
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php7.4-fpm.sock;
            fastcgi_param SCRIPT_FILENAME $request_filename;  
        }

        # Обработка других файлов
        location /phpmyadmin/ {
            try_files $uri $uri/ =404;
        }
    }
}
