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

1. Preparing the environment and install

    1.1. Creating the directories to receive the application

        .. code-block:: text

            #>$ mkdir -f /var/www/scielo
            #>$ cd /var/www/scielo

    1.2. Installing by GitHub

        .. code-block:: text

            $ wget https://github.com/scieloorg/Web/zipball/v5.21 
            $ unzip v5.21
            $ mv scielo-org-<code>/* .
            $ rmdir scielo-org-<code>
            $ rm v5.21

        .. warning::

            Change the version according to the latest version available at `GitHub <https://github.com/scieloorg/Web/tags>`_

        The created directory structure at /var/www/scielo must be 

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

    1.3. Install the ISIS and WISIS tools at the SciELO Site diretories


        **ISIS Package**

        inside /var/www/scielo/proc/cisis

        Download the CISIS package from the BIREME products `productos <http://bvsmodelo.bvsalud.org/php/level.php?lang=es&component=28&item=1>`_  website. The recomended version is **LINDG4**

        To check the CISIS version, after unzip the donwloaded file at /var/www/scielo/proc/cisis, run: 

        .. code-block:: text

            #/var/www/scielo/proc/cisis$>./mx what

        The result must be:

        .. code-block:: text

            CISIS Interface v5.2b/GC/W/L/M/32767/16/60/I - Utility MX
            CISIS Interface v5.2b/.iy0/Z/4GB/GIZ/DEC/ISI/UTL/INVX/B7/FAT/CIP/CGI/MX/W
            Copyright (c)BIREME/PAHO 2006. [!http://www.bireme.br/products/cisis]

        **WWWISIS Package**

        at /var/www/scielo/cgi-bin

        Download the WWWISIS package from the BIREME products `productos <http://bvsmodelo.bvsalud.org/php/level.php?lang=es&component=28&item=1>`_  website. The recomended version is **LINDG4**

        To check the WWWISIS version, access the website url:
        
        .. code-block:: text

            http://vm.scielo.br/cgi-bin/wxis.exe?hello
        

        The result must be:

        .. code-block:: text
        
            CISIS Interface v5.4.02_p5/GC/512G/W/L4/M/32767/16/60/I - XML !IsisScript WWWISIS 7.1d
            CISIS Interface v5.4.02_p5/.iy0/Z/GIZ/DEC/ISI/UTL/INVX/B7/FAT/CIP/CGI/MX/W
            Copyright (c)BIREME/PAHO 2008. [!http://www.bireme.br/products/cisis]
            Copyright (c)BIREME/PAHO 2008. [!http://bvsmodelo.bvsalud.org/php/index.php?lang=pt]
            Copyright (c)BIREME/PAHO 2008. [!http://bvsmodelo.bvsalud.org/php/level.php?lang=pt&component=28&item=1]

            WXIS release date: Sep 24 2008

    1.4. Configuring the file: /var/www/scielo/htdocs/scielo.def.php

        .. warning::
            
            Pay attention at this part, a lot of parameters must be configured.

        Coping the file scielo.def.php.template to scielo.def.php

        .. code-block:: text

            #var/www/scielo$>cp htdocs/scielo.def.php.template htdocs/scielo.def.php
            #var/www/scielo$>vi htdocs/scielo.def.php
    
        This file is splited by sections **[ ]** where each section have a group of parameters that could be changed. 

        At this part you will setup just the parameters necessary to run the website with basic features. For specific configurations for Bibliometria, Access Statistics, SCIMAGO, Crossref, Cache and other features, take a look at **Special Configurations**

        Configuring the SciELO Site Identification

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

        The APP_NAME parameter is given by the SciELO Team

        .. code-block:: text

            [SCIELO]
            '''SERVER_SCIELO=vm.scielo.br'''

        The SERVER_SCIELO must be changed by the intended domain of this SciELO Site installation. 

        .. code-block:: text

            [PATH]
            PATH_XSL=/var/www/scielo/htdocs/xsl/
            PATH_DATABASE=/var/www/scielo/bases/
            PATH_PDF=/var/www/scielo/bases/pdf
            PATH_TRANSLATION=/var/www/scielo/bases/translation/
            PATH_HTDOCS=/var/www/scielo/htdocs/
            PATH_OAI=/var/www/scielo/htdocs/oai/
            PATH_PROC=/var/www/scielo/proc/

    1.5. Configuring the file: /var/www/scielo/htdocs/iah/iah.def

        .. warning::

            Pay attention at this part, a lot of parameters must be configured.

        Copy the file iah.def.template to iah.def.php

        .. code-block:: text

            #var/www/scielo$>cp htdocs/iah/iah.def.template htdocs/iah/iah.def
            #var/www/scielo$>vi htdocs/iah/iah.def
        
        The content of “PATH_CGI-BIN” must be changed to the path of the applications previously configured on the APACHE Server.
        
        The content of “PATH_DATABASE” must be changed to the path of the applications previously configured on the APACHE Server.

        .. code-block:: text
    
            [PATH]
            PATH_CGI-BIN=/var/www/scielo/cgi-bin/iah/
            PATH_DATABASE=/var/www/scielo/bases/
    
        The content of “LOGO URL” must be changed to the path of the applications previously configured on the APACHE Server.

        The content of “HEADER URL” must be changed to the path of the applications previously configured on the APACHE Server.
        
        .. code-block:: text

            [HEADER]
            LOGO URL=www.scielo.br
            HEADER URL=www.scielo.br

        The content of “MANAGER E-MAIL” must be changed to the path of the applications previously configured on the APACHE Server.

        The directory configured in the parameter LOG_DATABASE must have write permission for the user apache

        .. code-block:: text

            [IAH]
            MANAGER E-MAIL=scielo@bireme.br
            LOG_DATABASE=/var/www/scielo/bases/logdia/iahlog

    1.6. Configuring the file /var/www/scielo/htdocs/iah/article.def

        .. warning::
        
            Pay attention at this part, a lot of parameters must be configured.

        Copy the file article.def.template to article.def.php

        .. code-block:: text

            #var/www/scielo$>mv htdocs/iah/article.def.template htdocs/iah/article.def
            #var/www/scielo$>vi htdocs/iah/article.def
    
        Changing the applications path

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

        Changing the application path

        .. code-block:: text        

            [VARIABLES]
            VARIABLE APP_PATH=/var/www/scielo
            VARIABLE APP_REVISTAS_PATH=/var/www/scielo/htdocs/revistas/

    1.7. Configuring the file /var/www/scielo/htdocs/iah/title.def

        .. warning::

            Pay attention at this part, a lot of parameters must be configured.

        Copy the file article.def.template to article.def.php

        .. code-block:: text

            #var/www/scielo$>cp htdocs/iah/title.def.template htdocs/iah/title.def
            #var/www/scielo$>vi htdocs/iah/title.def

        Change the application path

        .. code-block:: text

            [FILE_LOCATION]
            FILE HEADER.IAH=/var/www/scielo/cgi-bin/iah-styles/header.pft
            FILE scistyle.pft=/var/www/scielo/cgi-bin/iah-styles/scistyle.pft
            FILE places.pft=/var/www/scielo/cgi-bin/iah-styles/place-generico.pft
            FILE iso.pft=/var/www/scielo/cgi-bin/iah-styles/fbsrc1.pft
            FILE van.pft=/var/www/scielo/cgi-bin/iah-styles/fbsrc1.pft
            FILE abn.pft=/var/www/scielo/cgi-bin/iah-styles/fbsrc1.pft

        Change the application path

        .. code-block:: text
            
            [VARIABLES]
            VARIABLE APP_PATH=/var/www/scielo
            VARIABLE APP_REVISTAS_PATH=/var/www/scielo/htdocs/revistas/



Special Configurations (XML Google, DOAJ, Crossref DOI, SCIMAGO, etc)
=====================================================================

Bibliometria
------------

.. warning::

    Run each step from the **htdocs** directory.

Setup the cofiguration file.

    .. code-block:: text
        
        #var/www/scielo/htdocs$> vi scielo.def.php

Ask for the SciELO team for your "APP_NAME".

    .. code-block:: text

        [SITE_INFO]
        APP_NAME=scielo


Check if the domain of the Bibliometria Server is correct. It must be **scielo-log.scielo.br**

* Change the parameter "app=scielo" to app=\<same as APP_NAME\>
* Change the parameter according to the following example.

    .. code-block:: text

        [SCIELO]
        STAT_SERVER_CITATION=http://statbiblio.scielo.org/
        STAT_SERVER_COAUTH=http://statbiblio.scielo.org/


    .. code-block:: text

        [LOG]
        ENABLE_STATISTICS_LINK=1
        ENABLE_CITATION_REPORTS_LINK=1
        SERVER_LOG=scielo-log.scielo.br
        SERVER_LOG_PROC=scielo-log.scielo.br/
        SERVER_LOG_PROC_PATH=scielolog
        SCRIPT_LOG_NAME=scielolog/updateLog02.php
        SCRIPT_LOG_RUN=scielo-log.scielo.br/scielolog/scielolog03B2.php
        SCRIPT_TOP_TEN="http://scielo-log.scielo.br/scielolog/ofigraph20.php?app=APP_NAME"
        SCRIPT_ARTICLES_PER_MONTH="http://scielo-log.scielo.br/scielolog/ofigraph21.php?app=APP_NAME"



Access Statistics
-----------------

.. warning::

    Run each step from the **htdocs** directory.

Setup the cofiguration file.

    .. code-block:: text
        
        #var/www/scielo/htdocs$> vi scielo.def.php


Ask for the SciELO team for your "APP_NAME".

Change "SCRIPT_TOP_TEN" and "SCRIPT_ARTICLES_PER_MONTH" replacing app=scielo por app=\< same as APP_NAME \>.

    .. code-block:: text
    
        [SITE_INFO]
        APP_NAME=scielo 

        [LOG]
        ACTIVATE_LOG=1
        ENABLE_STATISTICS_LINK=1
        ACCESSSTAT_LOG_DIRECTORY=/var/www/scielo/bases/accesstat
        SERVER_LOG=scielo-log.scielo.br
        SERVER_LOG_PROC=scielo-log.scielo.br/
        SERVER_LOG_PROC_PATH=scielolog
        SCRIPT_LOG_NAME=scielolog/updateLog02.php
        SCRIPT_LOG_RUN=scielo-log.scielo.br/scielolog/scielolog03B2.php
        SCRIPT_TOP_TEN="http://scielo-log.scielo.br/scielolog/ofigraph20.php?app=scielo"
        SCRIPT_ARTICLES_PER_MONTH="http://scielo-log.scielo.br/scielolog/ofigraph21.php?app=scielo"
        ENABLE_ARTICLE_LANG_LINK=1

**To display the access statistics chart in the article page**

Setup the cofiguration file.

    .. code-block:: text
        
        #var/www/scielo/htdocs$> vi applications/scielo-org/scielo.def.php

In the group "requests_server" change the parameter "url"

    .. code-block:: text

        [requests_server]
        url="http://scielo-log.scielo.br/"

**Enable the Access Statistics link to register your access in the SciELO Server **

Setup the cofiguration file.

    .. code-block:: text
    
        #> vi htdocs/scielo.def.php


In the group "services" change the parameter "show_requests"

    .. code-block:: text

        [services]
        ...
        show_requests=1
        ...


Notes
`````

* Ask for the SciELO Team for your APP_NAME.
* Check if the configuration is fine looking for the following line in any SciELO Site page. 

    .. code-block:: text

        <img src="http://scielo-log.scielo.br/scielolog/updateLog02.php?app=scielo&amp;page=sci_home&amp;lang=en&amp;norm=iso&amp;doctopic=&amp;doctype=&amp;tlng=" border="0" height="1" width="1">

DOI Request
-----------

DOAJ
----

SCIMAGO
-------

El diretório raiz de los archivos del procesamiento de SCIMAGO es **proc/scielo_sjr**

Los pasos seguintes son ejecutados a partir del directório proc/scielo_sjr.

Copiar el archivo de configuración.


    .. code-block:: text

        #var/www/scielo/proc/scielo_sjr$> cp shs\config.sh.template shs\config.sh


Editar el archivo de configuración y cambiar los paths de las variables si necesario.

    .. code-block:: text

        #var/www/scielo/proc/scielo_sjr$> vi shs/config.sh


**Ejemplo del archivo de configuración**

    .. code-block:: text

        #!/bin/bash
        # ------------------------------------------------------------------------- #
        # variaveis com caminho para bases de dados utilizadas no processmento.
        # ------------------------------------------------------------------------- #
        export scielo_dir="/var/www/scielo"
        export scielo_proc="/var/www/scielo/proc"
        export database_dir="$scielo_dir/bases"
        export cisis_dir="$scielo_dir/proc/cisis"
        # ------------------------------------------------------------------------- #

**Fuera de uso**

    .. code-block:: text

        #JAVA RUNTIME ENVIRONMENT VARS
        export JAVA_HOME=/usr/local/jdk1.5.0_06

Ejecutar el script para recolectar las graficas de SCIMAGO.

    .. code-block:: text

        #var/www/scielo/proc/scielo_sjr$> cd shs/
        #var/www/scielo/proc/scielo_sjr$> ./sjr_run.sh


Envio de Bases para SciELO
--------------------------

    .. warning::

        Las configuraciones abajo deben ser ejecutadas desde el servidor de procesamiento

Acceder a la carpeta de procesamiento

    .. code-block:: text

        #>cd /var/www/scielo/proc 

Copiar el archivo de configuración de la cuenta de FTP

    .. code-block:: text

        #var/www/scielo/proc$> cp transf/Envia2MedlineLogOn-exemplo.txt transf/Envia2MedlineLogOn.txt

Editar el archivo de configuración de la cuenta de FTP

    .. code-block:: text

        #var/www/scielo/proc> vi transf/Envia2MedlineLogOn.txt


Cambiar los parametros del ftp de:

    .. code-block:: text

        open ftp.scielo.br
        user user_id user_passwd

para:

    .. code-block:: text

        open ftp.scielo.br
        user <scielo.code> <clave de accesos>


ejecutar

    .. code-block:: text

        #var/www/scielo/proc$>./Envia2MedlinePadrao.bat 


Notes
`````

* Solicitar al equipo SciELO el "code" y clave de acceso para la cuenta FTP.
* Configura un ***cron*** para ejecutar el procedimiento periodicamente. (Semanualmente)
* El archivo de log para consultas en casos de problemas esta en:
    * /var/www/proc/log/envia2medlineFTP.log
    * /var/www/proc/log/envia2medline.log

----------
Updating
----------

Download the latest version available in a temporary directory

All collection package is up to date with the latest version, see the corresponding code of your distribution at `GitHub <https://github.com/scieloorg/Web/branches>`_

**Switch the "master" in the syntax bellow with the corresponding code of your collection.**

    .. code-block:: text

        #> cd /tmp
        #tmp$> wget https://github.com/scieloorg/Web/tarball/master --no-check-certificate


Expanding the downloaded file. The file will be named like (scieloorg-Web-v5.14-12-gd37aad4.tar.gz).
The file name will be different for each version.

    .. code-block:: text
    
        #tmp$> tar xvfzp scieloorg-Web-v5.14-12-gd37aad4.tar.gz


The created file structure will be like:

    .. code-block:: text

        scieloorg-Web-XXXXXXXX-XXXXXXXX/
        bases/
        bases_modelo/
        bases-work/
        bases-work_modelo/
        cgi-bin/
        htdocs/
        logs/
        proc/
        serial/
        serial_modelo/ 


Compressing only the necessary folders for the update.

    .. code-block:: text

        #tmp$> cd scieloorg-Web-XXXXXXXX-XXXXXXXX
        #tmp/scieloorg-Web-XXXXXXXX-XXXXXXXX$> tar cvfzp scielo_tmp.tgz htdocs/ cgi-bin/ proc/


Switching to the SciELO Site folder.

    .. code-block:: text

        #> cd /var/www/scielo

Moving the tgz temporary file to the SciELO Web folder.

    .. code-block:: text

        #tmp/scieloorg-Web-XXXXXXXX-XXXXXXXX$> mv scielo_tmp.tgz .


Expanding the file.

    .. code-block:: text

        #tmp/scieloorg-Web-XXXXXXXX-XXXXXXXX$> cd /var/www/scielo
        #var/www/scielo$> tar xvfzp scielo_tmp.tgz

Removing the tgz file

    .. code-block:: text

        #var/www/scielo$> rm scielo_tmp.tgz

Notes
=====

Take a look at versionOverview.txt file to check if the updated web site has the newer version of ScIELO Site: http://www.scielo.br/versionOverview.txt
