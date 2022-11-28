```
./configure --prefix=/usr/1ocal/nginx \
--with-http_stub_status_module \
--with-http_v2_module \
--with-http_ssl_module \
--with-http_gzip_static_module \
--with-http_realip_module \
--with-http_flv_module \
--with-stream \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib/nginx/modules \
--conf-path=/usr/local/nginx/conf/nginx.conf \
--user=www \
--group=www
```

