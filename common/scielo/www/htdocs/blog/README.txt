WordPress Multi User
--------------------

WordPress MU is a multi user version of WordPress.

If you're not comfortable editing PHP code, taking care of a complex
webserver and database system and being pro-active about following
developments of this project then run, don't walk, to 
http://wordpress.com/ and sign yourself and your friends up to free blogs.
It's easier in the long run and you'll save yourself a lot of pain
and angst.

Apache
======
Apache must be configured so that mod_rewrite works. Here are 
instructions for Apache 2. Apache 1.3 is very similar.

1. Make sure a line like the following appears in your httpd.conf
LoadModule rewrite_module /usr/lib/apache2/modules/mod_rewrite.so

2. In the <Directory> directive of your virtual host, look for this
line
"AllowOverride None"
and change it to
"AllowOverride FileInfo Options"

3. In the <VirtualHost> section of the config file for your host there
will be a line defining the hostname. You need to add the following 
if you want virtual hosts to work properly:
"ServerAlias *.domain.tld"
Replace domain.tld with whatever your one is, and remove the quotes.


DNS
===
If you want to host blogs of the form http://blog.domain.tld/ where 
domain.tld is the domain name of your machine then you must add a 
wildcard record to your DNS records.
This usually means adding a "*" hostname record pointing at your 
webserver in your DNS configuration tool.
Matt has a more detailed explanation:
http://photomatt.net/2003/10/10/wildcard-dns-and-sub-domains/


PHP
===
1. Don't display error messages to the browser. This is almost always
turned off but sometimes when you're testing you turn this on and forget
to reset it.

2. If your PHP is compiled with memory limit checks, the default is 8MB
which is much too small. You should increase this to at least 32MB or 64MB
to avoid PHP out of memory errors. Look for "memory_limit" in your php.ini
file.

3. GLOBAL variables must be turned off. This is one of the first things
any security aware admin will do. These days the default is for it to
be off!

The easiest way of configuring it is via the .htaccess file that is
created during the install. If you haven't installed WPMU yet then edit
the file htaccess.dist in this directory and add these two lines at the
top:

php_flag register_globals 0
php_flag display_errors 0

This is NOT included in that file by default because it doesn't work on
all machines. If it doesn't work on your machine, you'll get a cryptic
"500 internal error" after you install WPMU. To remove the offending lines
just edit the file ".htaccess" in your install directory and you'll see
them at the top. Delete and save the file again.
Read here for how to enable this: http://ie.php.net/configuration.changes

If you don't want to edit your .htaccess file then you need to change your
php.ini. It's beyond the scope of this README to know exactly where it is
on your machine, but if you're on a shared hosted server you probably
don't have access to it as it requires root or administrator privileges
to change.

If you do have root access, try "locate php.ini" or check in:

/etc/php4/apache2/php.ini
/usr/local/lib/php.ini

Once you have opened your php.ini, look for the sections related to 
register_globals and display_errors. Make sure both are Off like so:

display_errors = Off
register_globals = Off

You'll have to restart Apache after you modify your php.ini for the 
settings to be updated.

4. If you want to restrict blog signups, set the restrict domain email 
setting in the admin.


Install
=======
1. Download and unzip the WordPress MU package, if you haven't already.
   The unzipped files will be created in a directory named "wordpressmu"
   followed by a version number.
2. Create a database for WordPress MU on your web server, as well as a 
   MySQL user who has all privileges for accessing and modifying it.
3. Place the WordPress MU files in the desired location on your web server:
   * If you want to integrate WordPress MU into the root of your 
     domain (e.g. http://example.com/), move or upload all the files and
     directories of the unzipped WordPress MU directory into the root 
     directory of your web server.
   * If you want to have your WordPress MU installation in its own 
     subdirectory on your web site (e.g. http://example.com/blogs/), 
     rename the directory wordpressmu to the name you'd like the 
     subdirectory to have and move or upload it to your web server. 
     For example if you want the WordPress MU installation in a 
     subdirectory called "blog", you should rename the directory called 
     "wordpressmu" to "blogs" and upload it to the root directory of your 
     web server. 
4. Make sure your install directory and the wp-contents directory are
   writeable by the webserver.
5. Run the WordPress MU installation script by accessing index.php
   in your favorite web browser.
   * If you installed WordPress MU in the root directory, you should 
     visit: http://example.com/index.php
   * If you installed WordPress MU in its own subdirectory called 
     blogs, for example, you should visit: http://example.com/blogs/index.php 
(Adapted from http://codex.wordpress.org/Installing_WordPress)

If you're upgrading, skip to the end of this document.

ERROR LOGGING
=============
If you are developing a site based on WPMU it is recommended that you
turn on PHP error logging. Look in your php.ini for the section marked
"Error handling and logging" where you can configure it.

Mysql database errors are logged to the PHP error log if enabled or it
can also send error reports to a file of your choice. After installing,
edit wp-config.php and define a constant, "ERRORLOGFILE", pointing at
your MySQL error log. This file must be writeable by your webserver.
Please don't log to a file visible by your webserver or people may 
figure out they can download it.
Example definition:
define( "ERRORLOGFILE", "/tmp/mysql.log" );


UPGRADING
=========
Please see this page for instructions on upgrading your install:
http://codex.wordpress.org/Upgrading_WPMU


Support Forum and Bug Reports
=============================
Please read http://codex.wordpress.org/Debugging_WPMU before
asking any questions. Without all the information required there
we'll just ask for it anyway or worse, your request will be ignored.

http://mu.wordpress.org/forums/

Trac is our bug tracking system. Again, please read the above link
before submitting a bug report.
http://trac.mu.wordpress.org/report/1

You can login to both sites using your wordpress.org username and
password.

http://mu.wordpress.org/
