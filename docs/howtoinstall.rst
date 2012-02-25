==============
How to Install
==============

------------
Requirements
------------

Linux Server
============

* Always use an up to date Linux distribution.
    * PHP 5.2.X
    * Apache 2.2.X
    * PHP Modules
        * libpng
        * soap
        * zlib
        * XSL
        * XML
    * Git Client

Guide for CentOS Distributions

Windows Server
==============

It is not recomended use windows as a server, considering that all the **SciELO Site** releases are only officialy tested at Linux. But if you wanna try, all the libraries and services are compatible with Windows Operating Systems.

-------
Install
-------

SciELO Site Installation guide
===============================

1. Preparación del ambiente y instalación

    1.1. Crear la estructura de carpetas de la aplicación SciELO

        .. code-block:: text

            #>$ mkdir -f /var/www/scielo
            #>$ cd /var/www/scielo

    1.2. Instalando através del GitHub

        .. code-block:: text

            $ wget https://github.com/scieloorg/Web/zipball/v5.21 
            $ unzip v5.21
            $ mv scielo-org-<code>/* .
            $ rmdir scielo-org-<code>
            $ rm v5.21

        .. warning::

            Change the version according to the latest version available at `GitHub <https://github.com/scieloorg/Web/tags>`_

        La estructura creada bajo la carpeta /var/www/scielo es

        .. code-block:: text

            bases/
            bases-work_modelo/
            bases_modelo/
            cgi-bin/
            docs/
            htdocs/
            ignore.txt
            proc/
            serial_modelo/ 

    1.3. Añadir los paquetes de ISIS y WWWISIS en el directório de la aplicación


        **Paquete ISIS**

        en la carpeta /var/www/scielo/proc/cisis

        Bajar el paquete CISIS del sitio de `productos <http://bvsmodelo.bvsalud.org/php/level.php?lang=es&component=28&item=1>`_ de BIREME. La versión recomendada es la versión **LINDG4**

        Para comprobar la versión del CISIS, despues de descomprimir el archivo en /var/www/scielo/proc/cisis, ejecutar: 

        .. code-block:: text

            #/var/www/scielo/proc/cisis$>./mx what

        El resultado deverá ser:

        .. code-block:: text

            CISIS Interface v5.2b/GC/W/L/M/32767/16/60/I - Utility MX
            CISIS Interface v5.2b/.iy0/Z/4GB/GIZ/DEC/ISI/UTL/INVX/B7/FAT/CIP/CGI/MX/W
            Copyright (c)BIREME/PAHO 2006. [!http://www.bireme.br/products/cisis]

        **Paquete WWWISIS**

        En la carpeta /var/www/scielo/cgi-bin

        Bajar el paquete WWWISIS del sitio de `productos <http://bvsmodelo.bvsalud.org/php/level.php?lang=pt&component=28&item=2>`_ de BIREME. La versión recomendada es la version **LINDG4**

        Para comprobar la versión de WWWISIS y también comprobar si el **Apache** se configuró correctamente para ejecutar scripts CGI, acceder la URL:

        .. code-block:: text

            http://vm.scielo.br/cgi-bin/wxis.exe?hello
        

        El resultado deveberá ser:

        .. code-block:: text
        
            CISIS Interface v5.4.02_p5/GC/512G/W/L4/M/32767/16/60/I - XML !IsisScript WWWISIS 7.1d
            CISIS Interface v5.4.02_p5/.iy0/Z/GIZ/DEC/ISI/UTL/INVX/B7/FAT/CIP/CGI/MX/W
            Copyright (c)BIREME/PAHO 2008. [!http://www.bireme.br/products/cisis]
            Copyright (c)BIREME/PAHO 2008. [!http://bvsmodelo.bvsalud.org/php/index.php?lang=pt]
            Copyright (c)BIREME/PAHO 2008. [!http://bvsmodelo.bvsalud.org/php/level.php?lang=pt&component=28&item=1]

            WXIS release date: Sep 24 2008

    1.4. Configuración inicial del archivo /var/www/scielo/htdocs/scielo.def.php

        .. warning::
            
            Este es un tema que requiere mayor atención, puesto que hay que configurar muchos parámetros.

        Copiar el archivo scielo.def.php.template para scielo.def.php

        .. code-block:: text

            #var/www/scielo$>cp htdocs/scielo.def.php.template htdocs/scielo.def.php
            #var/www/scielo$>vi htdocs/scielo.def.php
    

        El archivo esta organizado en secciones identificadas por **[ ]**, donde cada sección tiene un grupo de variables

        En ese punto serán configurados apenas parametros que permiten la utilización de los componentes basicos del sitios SciELO. Para configuración de servicios especificos como, Bibliometria, Estadísticas de Accesos, SCIMAGO, Google Scholar, Crossref, Cache, y otros mirar **Configuraciones Especiales**

        Configuración de identificación básica de la instalación

        .. code-block:: text

            [SITE_INFO]
            ''SITE_NAME=SciELO - Scientific Electronic Library Online''
            ''SHORT_NAME=Scielo Brazil''
            ''SITE_AUTHOR=FAPESP – BIREME''
            ''ADDRESS_1=Rua Botucatu, 862 - Vila Clementino''
            ''ADDRESS_2=04023-901 São Paulo SP''
            ''COUNTRY=Brasil''
            ''PHONE_NUMBER="+55 11 5576-9863'
            ''FAX_NUMBER="+55 11 5575-8868"''
            ''E_MAIL=!scielo@bireme.br''
            ''STANDARD_LANG=en''
            '''APP_NAME=scielo'''

        El contenido de APP_NAME debrá ser consultado con el equipo tecnico de SciELO

        .. code-block:: text

            [SCIELO]
            '''SERVER_SCIELO=vm.scielo.br'''

        El contenido de SERVER_SCIELO deberá ser cambiado por el dominio del sitio SciELO configurado en el APACHE

        .. code-block:: text

            [PATH]
            PATH_XSL=/var/www/scielo/htdocs/xsl/
            PATH_DATABASE=/var/www/scielo/bases/
            PATH_PDF=/var/www/scielo/bases/pdf
            PATH_TRANSLATION=/var/www/scielo/bases/translation/
            PATH_HTDOCS=/var/www/scielo/htdocs/
            PATH_OAI=/var/www/scielo/htdocs/oai/
            PATH_PROC=/var/www/scielo/proc/

    1.5. Configurar el archivo /var/www/scielo/htdocs/iah/iah.def

        .. warning::

            Este es un tema que requiere mayor atención, puesto que hay que configurar muchos parámetros.

        Copiar el archivo iah.def.template para iah.def.php

        .. code-block:: text

            #var/www/scielo$>cp htdocs/iah/iah.def.template htdocs/iah/iah.def
            #var/www/scielo$>vi htdocs/iah/iah.def
        
        El contenido de “PATH_CGI-BIN” deberá ser cambiado para el path de la aplicación SciELO configurado en el APACHE
        
        El contenido de “PATH_DATABASE” deberá ser cambiado para el path de la aplicación SciELO configurado en el APACHE

        .. code-block:: text
    
            [PATH]
            PATH_CGI-BIN=/var/www/scielo/cgi-bin/iah/
            PATH_DATABASE=/var/www/scielo/bases/
    
        El contenido de “LOGO URL” deberá ser cambiado para el dominio de la aplicación SciELO configurado en el APACHE
        
        El contenido de “HEADER URL” deberá ser cambiado para el dominio de la aplicación SciELO configurado en el APACHE

        .. code-block:: text

            [HEADER]
            LOGO URL=www.scielo.br
            HEADER URL=www.scielo.br

        El contenido de “MANAGER E-MAIL” deberá ser cambiado por el email del administrador del nuevo sitio SciELO

        La carpeta configurada en el parámetro LOG_DATABASE deberá tener permisos de escrita para el usuario apache o nobody

        .. code-block:: text

            [IAH]
            MANAGER E-MAIL=scielo@bireme.br
            LOG_DATABASE=/var/www/scielo/bases/logdia/iahlog

    1.6. Configurar el archivo /var/www/scielo/htdocs/iah/article.def

        .. warning::
        
            Este es un tema que requiere mayor atención, puesto que hay que configurar varios parámetros.

        Copiar el archivo article.def.template para article.def.php

        .. code-block:: text

            #var/www/scielo$>mv htdocs/iah/article.def.template htdocs/iah/article.def
            #var/www/scielo$>vi htdocs/iah/article.def
    
        Cambiar el path de la aplicación

        .. code-block:: text

            [FILE_LOCATION]
            FILE HEADER.IAH=/var/www/scielo/cgi-bin/iah-styles/header.pff
            FILE QUERY.IAH=/var/www/scielo/cgi-bin/iah-styles/query.pft
            FILE LIST6003.PFT=/var/www/scielo/cgi-bin/iah-styles/list6003.pft
            FILE PROC.PFT=/var/www/scielo/htdocs/pfts/proc_split_mst.pft
            FILE iso.pft=/var/www/scielo/cgi-bin/iah-styles/fbiso.pft
            FILE abn.pft=/var/www/scielo/cgi-bin/iah-styles/fbabn.pft
            FILE van.pft=/var/www/scielo/cgi-bin/iah-styles/fbvan.pft
            FILE places.pft=/var/www/scielo/cgi-bin/iah-styles/place-generico.pft
            FILE month1.pft=/var/www/scielo/cgi-bin/iah-styles/month1.pft
            FILE month2.pft=/var/www/scielo/cgi-bin/iah-styles/month2.pft
            FILE scistyle.pft=/var/www/scielo/cgi-bin/iah-styles/scistyle.pft
            FILE AHBTOP.HTM=/var/www/scielo/cgi-bin/iah-styles/%lang%/ahbtop.htm
            FILE AHLIST.PFT=/var/www/scielo/cgi-bin/iah-styles/%lang%/ahlist.pft
            FILE ahlist.pft=/var/www/scielo/cgi-bin/iah-styles/%lang%/ahlist.pft
            FILE citation.xml=/var/www/scielo/cgi-bin/iah-styles/fbisoXML.pft

        Cambiar el path de la aplicación

        .. code-block:: text        

            [VARIABLES]
            VARIABLE APP_PATH=/var/www/scielo
            VARIABLE APP_REVISTAS_PATH=/var/www/scielo/htdocs/revistas/

    1.7. Configurar el archivo /var/www/scielo/htdocs/iah/title.def

        .. warning::

            Este es un tema que requiere mayor atención, puesto que hay que configurar muchos parámetros.

        Copiar el archivo article.def.template para article.def.php

        .. code-block:: text

            #var/www/scielo$>cp htdocs/iah/title.def.template htdocs/iah/title.def
            #var/www/scielo$>vi htdocs/iah/title.def

        Cambiar el path de la aplicación

        .. code-block:: text

            [FILE_LOCATION]
            FILE HEADER.IAH=/var/www/scielo/cgi-bin/iah-styles/header.pft
            FILE scistyle.pft=/var/www/scielo/cgi-bin/iah-styles/scistyle.pft
            FILE places.pft=/var/www/scielo/cgi-bin/iah-styles/place-generico.pft
            FILE iso.pft=/var/www/scielo/cgi-bin/iah-styles/fbsrc1.pft
            FILE van.pft=/var/www/scielo/cgi-bin/iah-styles/fbsrc1.pft
            FILE abn.pft=/var/www/scielo/cgi-bin/iah-styles/fbsrc1.pft

        Cambiar el path de la aplicación

        .. code-block:: text
            
            [VARIABLES]
            VARIABLE APP_PATH=/var/www/scielo
            VARIABLE APP_REVISTAS_PATH=/var/www/scielo/htdocs/revistas/



Special Configurations (XML Google, DOAJ, Crossref DOI, SCIMAGO, etc)
=====================================================================

Bibliometria
------------

Estadísticas de Accesos
-----------------------

Requisición de DOI
------------------

DOAJ
----

SCIMAGO
-------

Envio de Bases para SciELO
--------------------------

------
Update
------

Update Guide from SciELO Web Site. [[read|actualizacion_en]]