server {
    listen 80;
    server_name site-2.ru;

    root /var/www/site-2.ru/DOC_ROOT;
    index index.php index.html tinyfilemanager.php;

    access_log /var/www/site-2.ru/logs/access.log;
    error_log /var/www/site-2.ru/logs/error.log;

    location / {
	try_files $uri /tinyfilemanager/tinyfilemanager.php;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php7.4-fpm-site-2.ru.sock;  # По умолчанию используем PHP 7.4
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    }

    location ~ \.php81$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.1-fpm-site-2.ru.sock;  # Для файлов с суффиксом .php81
        fastcgi_split_path_info ^(.+\.php)(.*)$;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

     location /phpmyadmin {
        alias /var/www/site-2.ru/DOC_ROOT/phpmyadmin;  # Используем alias вместо root
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
