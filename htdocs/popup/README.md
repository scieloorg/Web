# Pop-up Surveys 

A pop-up survey using Alertify.js and submitting to a Google Form in the background. 

This code is being used to collect survey responses from [SciELO](http://www.scielo.org) and from [RedALyC](http://www.redalyc.org) as part of the research component of the _[Quality in the Open Scholarly Communication of Latin America](http://flacso.org.br/oa/calidad-en-la-comunicacion-cientifica-abierta-de-america-latina/?lang=en)_ project, funded by IDRC, with the participation of the Public Knowleedge Project, FLACSO Brazil, SciELO, RedALyC, and Latindex. 


### Installation

Put a DIV somewhere on your page with the current user's IP address and the ID "userIP", e.g.: 

	<div id="userIP">10.0.0.1</div>

**If you do not have jQuery at all:**

Add this to the <head> (change path to the pop-up path):

    <script type="text/javascript" src="/popup/jquery-1.9.1.min.js"></script>


**If you have jQuery >= 1.9 already running on your site, or if you added the line above:** 

    <script type="text/javascript">
	$(document).ready(function() { 
		var options = {
			language: 'en', // en|es|pt
			popup_absolute_path; '/popupsurveys/' // change to absolute path where you've placed this code
		}

		$.getScript(options.popup_absolute_path + 'pkp_flacso_popup.v2.min.js', function() {
			pkp_flacso_popup(options);
		}); 
	});
	</script>
	
**If you already have jQuery running on your site, but it is a version < 1.9:**

    <script type="text/javascript">
	$(document).ready(function() { 
		var options = {
			language: 'en', // en|es|pt
			popup_absolute_path: '/popupsurveys/' // change to absolute path where you've placed this code
		}
		
		$.getScript(options.popup_absolute_path + 'jquery-1.9.1.min.js', function() {
	        // Assign the last inserted JQuery version to a new variable, to avoid
	        // conflicts with the current version in $ variable.
			options.jQuery = $;
			$.getScript(options.popup_absolute_path + 'pkp_flacso_popup.v2.min.js', function() {
				pkp_flacso_popup(options);
				jQuery.noConflict(true);
			}); 
		});
	});
	</script>
