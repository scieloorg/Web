@echo off

set CLASSPATH=.;HTTPClient.jar

%JAVA_HOME%/bin/java org.crossref.client.SubmissionUploader %*