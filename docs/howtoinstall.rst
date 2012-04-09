================================================
Installation and configuration of SciELO Website 
================================================

REQUIREMENTS
============
    - CentOS release 5.6
    - Apache 2.2.3 or later
    - PHP 5.2.10 (required)
        - PHP Modules
            - libpng
            - soap
            - zlib
            - XSL
            - XML
    - vim
    - Git client
    - basic knowledge of Linux Administration
    - wget


Checking the version
====================

The <SciELO website>/versionOverview.txt displays the current version of the website.
 
Check ScIELO Site: http://www.scielo.br/versionOverview.txt to see the most recent version.


Installation
============

1. Preparing the environment and install

    1.1. Creating the directories to receive the application

        .. code-block:: text

            #>$ mkdir -f /var/www/scielo
            #>$ cd /var/www/scielo

    1.2. Installing by GitHub


        <branch_or_tag> 

            - tag is corresponding to the versions. 
                E.g.: v5.21. 
                Link to the versions at `SciELO's GitHub <https://github.com/scieloorg/Web/tags>`_
            - branch is the current version plus customizations for the country/collection.
                E.g.: scielo_esp
                Check the `branch name of each collection <network.html>`_.

        <randomic_code>
            a code generated after unzip execution


        .. code-block:: text

            $ wget https://github.com/scieloorg/Web/zipball/<branch_or_tag> 
            $ unzip <branch_or_tag>


        A folder named as scieloorg-<randomic_code> will be created.

        .. code-block:: text

            $ mv scieloorg-<randomic_code>/* .
            $ rmdir scieloorg-<randomic_code>
            $ rm <branch_or_tag>



        .. warning::

            Change <branch_or_tag> according to the latest version or the branch of the collection


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


        .. image:: img/en/Metodologia-linux003.png


    1.3. Install the CISIS and WISIS tools at the SciELO Site diretories


        **CISIS Package**

        inside /var/www/scielo/proc/cisis

        Download the `CISIS package <http://bvsmodelo.bvsalud.org/php/level.php?lang=es&component=28&item=1>`_ from the BIREME products website.

        Set permissions to execute mx.

        The recommended version is **LINDG4**

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

        Download the `WWWISIS package <http://bvsmodelo.bvsalud.org/php/level.php?lang=es&component=28&item=1>`_ from the BIREME products website.
        
        Set permission to execute wxis.

        The recommended version is **LINDG4**

        To check the WWWISIS version, at /var/www/scielo/cgi-bin/, run:

        .. code-block:: text

            #/var/www/scielo/cgi-bin$>wxis hello

        If you have already configured the virtual host, you can check WWWISIS version by accessing the url:

        .. code-block:: text

            http://vm.scielo.br/cgi-bin/wxis.exe?hello
        
        where vm.scielo.br is the website address

        The result must be:

        .. code-block:: text
        
            CISIS Interface v5.4.02_p5/GC/512G/W/L4/M/32767/16/60/I - XML !IsisScript WWWISIS 7.1d
            CISIS Interface v5.4.02_p5/.iy0/Z/GIZ/DEC/ISI/UTL/INVX/B7/FAT/CIP/CGI/MX/W
            Copyright (c)BIREME/PAHO 2008. [!http://www.bireme.br/products/cisis]
            Copyright (c)BIREME/PAHO 2008. [!http://bvsmodelo.bvsalud.org/php/index.php?lang=pt]
            Copyright (c)BIREME/PAHO 2008. [!http://bvsmodelo.bvsalud.org/php/level.php?lang=pt&component=28&item=1]

            WXIS release date: Sep 24 2008

Configuration
=============

    1.4. Configuring the file: /var/www/scielo/htdocs/scielo.def.php

        .. warning::
            
             Some parameters must be configured.

        Copying the file scielo.def.php.template to scielo.def.php

        .. code-block:: text

            #var/www/scielo$>cp htdocs/scielo.def.php.template htdocs/scielo.def.php
            #var/www/scielo$>vi htdocs/scielo.def.php
    
        This file is organized by blocks name using  **[BLOCK_NAME]**. 
        Each section have a set of parameters to be edited. 

        At this moment, you will configure only the mandatory parameters to run the website with basic features.
        
        To configure other features, such as Bibliometrics, Access Statistics, SCIMAGO, etc, read `Special configurations`_.

        Configuring the SciELO Site Identification

        .. code-block:: text

            [SITE_INFO]
            SITE_NAME=SciELO - Scientific Electronic Library Online
            SHORT_NAME=Scielo Brazil
            SITE_AUTHOR=FAPESP – BIREME
            ADDRESS_1=Rua Botucatu, 862 - Vila Clementino
            ADDRESS_2=04023-901 São Paulo SP
            COUNTRY=Brasil
            PHONE_NUMBER="+55 11 5576-9863'
            FAX_NUMBER="+55 11 5575-8868"
            E_MAIL=scielo@bireme.br
            STANDARD_LANG=en
            APP_NAME=scielo

        The **APP_NAME** parameter value is provided by the SciELO Team.  

        .. code-block:: text

            [SCIELO]
            SERVER_SCIELO=vm.scielo.br

        Set SERVER_SCIELO to domain of your SciELO Site installation. 

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

             some parameters must be configured.

        Copy the file iah.def.template to iah.def and open it to edit.

        .. code-block:: text

            #var/www/scielo$>cp htdocs/iah/iah.def.template htdocs/iah/iah.def
            #var/www/scielo$>vi htdocs/iah/iah.def
        
        The value for **PATH_CGI-BIN** must be changed to the application path previously configured for the virtual host on the APACHE Server.
        
        The value for **PATH_DATABASE** must be changed to the application path previously configured for the virtual host on the APACHE Server.

        .. code-block:: text
    
            [PATH]
            PATH_CGI-BIN=/var/www/scielo/cgi-bin/iah/
            PATH_DATABASE=/var/www/scielo/bases/
    
        The value for **LOGO URL** must be changed to the application path previously configured for the virtual host on the APACHE Server.

        The value for **HEADER URL** must be changed to the application path previously configured for the virtual host on the APACHE Server.
        
        .. code-block:: text

            [HEADER]
            LOGO URL=www.scielo.br
            HEADER URL=www.scielo.br

        The value for **MANAGER E-MAIL** must be changed to the application path previously configured for the virtual host on the APACHE Server.

        The directory configured for LOG_DATABASE must have write permission for the user apache

        .. code-block:: text

            [IAH]
            MANAGER E-MAIL=scielo@bireme.br
            LOG_DATABASE=/var/www/scielo/bases/logdia/iahlog

    1.6. Configuring the file /var/www/scielo/htdocs/iah/article.def

        .. warning::
        
             some parameters must be configured.

        Copy the file article.def.template to article.def

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

             some parameters must be configured.

        Copy the file title.def.template to title.def

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



Special Configurations
======================

To configure other features, such as Bibliometrics, Access Statistics, SCIMAGO, etc.

Google Analytics
----------------

.. warning::

    Run each step from the **htdocs** directory.

Edit the configuration file.

    .. code-block:: text
        
        #var/www/scielo/htdocs$> vi scielo.def.php

Ask SciELO team for your **APP_NAME**.

    .. code-block:: text

        ACTIVATE_GOOGLE=1
        GOOGLE_CODE=<google_code>


    e.g.:

    .. code-block:: text
         
        ACTIVATE_GOOGLE=1
        GOOGLE_CODE=UA-01010101010-1

**Note:**
    To have this code, you must have an account in Google Analytics.

Bibliometric reports website
----------------------------

.. warning::

    Run each step from the **htdocs** directory.

Edit the configuration file.

    .. code-block:: text
        
        #var/www/scielo/htdocs$> vi scielo.def.php

Ask SciELO team for your **APP_NAME**.

    .. code-block:: text

        [SITE_INFO]
        APP_NAME=scielo


Indicate the domain for Bibliometric reports website editing STAT_SERVER_CITATION and STAT_SERVER_COAUTH.

* Change the parameter **app=scielo** to app=\<same as APP_NAME\>
* Change the parameter according to the following example.

    **Note:** Bibliometric reports website is other website which is also part of SciELO.


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

Edit the configuration file.

    .. code-block:: text
        
        #var/www/scielo/htdocs$> vi scielo.def.php


Ask SciELO team for your **APP_NAME**.

Set **SCRIPT_TOP_TEN** and **SCRIPT_ARTICLES_PER_MONTH**, replacing app=scielo by app=\< same as APP_NAME \>.

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

Set show_requests to 1, to enable the Access Statistics link.

    .. code-block:: text

        [services]
        ...
        show_requests=1
        ...

Chart of Access statistics
--------------------------

Edit the configuration file.

    .. code-block:: text
        
        #var/www/scielo/htdocs$> vi applications/scielo-org/scielo.def.php

At the block named  *[requests_server]* set *url*

    .. code-block:: text

        [requests_server]
        url="http://scielo-log.scielo.br/"


    .. warning:: 

        Check if the configuration is correct, looking for the following line in any SciELO website page. 


    .. code-block:: text

        <img src="http://scielo-log.scielo.br/scielolog/updateLog02.php?app=scielo&amp;page=sci_home&amp;lang=en&amp;norm=iso&amp;doctopic=&amp;doctype=&amp;tlng=" border="0" height="1" width="1">

SCIMAGO
-------

The root directory for this processing is **/var/www/scielo/proc/scielo_sjr**

The following steps run at the directory proc/scielo_sjr.

Copying the config file.


    .. code-block:: text

        #var/www/scielo/proc/scielo_sjr$> cp shs/config.sh.template shs/config.sh

Editing the config file and changing the paths if necessary.

    .. code-block:: text

        #var/www/scielo/proc/scielo_sjr$> vi shs/config.sh


**Config file sample**. If you are already using /var/www/scielo as the application path, so no changes need.

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

**Out of use**

    .. code-block:: text

        #JAVA RUNTIME ENVIRONMENT VARS
        export JAVA_HOME=/usr/local/jdk1.5.0_06

Run the script to harvest the SCIMAGO charts.

    .. code-block:: text

        #var/www/scielo/proc/scielo_sjr$> cd shs/
        #var/www/scielo/proc/scielo_sjr$> ./sjr_run.sh

DOI Request
-----------

DOAJ
----


Updating
========

1. Create a temporary folder

2. `Identify your branch <network.html>`_

    https://github.com/scieloorg/Web/tarball/<branch_name>
    
    .. code-block:: text

        #> cd /tmp
        #tmp$> wget https://github.com/scieloorg/Web/tarball/<branch_name> --no-check-certificate

    A file such as scieloorg-Web-<version-code>.tar.gz will be created. Where <version-code> changes according to the application version.

3. Extract the downloaded file. 

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

4. Compress only the necessary folders to update.

    .. code-block:: text

        #tmp$> cd scieloorg-Web-XXXXXXXX-XXXXXXXX
        #tmp/scieloorg-Web-XXXXXXXX-XXXXXXXX$> tar cvfzp scielo_tmp.tgz htdocs/ cgi-bin/ proc/

    scielo_tmp.tgz will only have htdocs, cgi-bin, proc folders.

5. Move the tgz temporary file to the SciELO Website folder.

    .. code-block:: text

        #tmp/scieloorg-Web-XXXXXXXX-XXXXXXXX$> mv scielo_tmp.tgz /var/www/scielo


6. Go to the application SciELO website folder.

    .. code-block:: text

        #tmp/scieloorg-Web-XXXXXXXX-XXXXXXXX$> cd /var/www/scielo

7. Extract scielo_tmp.tgz

    .. code-block:: text

        #var/www/scielo$> tar xvfzp scielo_tmp.tgz

8. Remove the tgz file

    .. code-block:: text

        #var/www/scielo$> rm scielo_tmp.tgz

