FROM local/base

RUN yum install -y httpd

EXPOSE 80

ADD index.html /var/www/html/index.html
RUN rm /etc/httpd/conf.d/welcome.conf

CMD /usr/sbin/httpd -DFOREGROUND
