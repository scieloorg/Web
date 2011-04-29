package org.crossref.client;

import HTTPClient.*;
import java.io.File;


/**
 * CrossRef synch. query sample. Please refer to CrossRef's system interface (http://doi.crossref.org/doc/userdoc.html) for more information
 * 
 * @author Hisham Shahtout - Atypon Systems (http://www.atypon.com)
 * @version 1.1
 * 
 * Revision history
 * ----------------
 * v1.1 @ 1/23/2003:  
 *   - Defined constants METADATA_QUERY_TYPE and DOI_QUERY_TYPE
 *   - Defined constants AREA_LIVE and AREA_TEST
 *   - Defined constants RESULT_FORMAT_PIPED , RESULT_FORMAT_XML
 *   - doQuery returns an HTTPResponse instance instead of printing out the results
 *   - made readFromFile () a public method.
 * 
 */
public class CrossRefQuery
{
   static public final String METADATA_QUERY_TYPE="q";
   static public final String DOI_QUERY_TYPE="d";
   
   static public final String AREA_LIVE="live";
   static public final String AREA_TEST="test";
   
   static public final String RESULT_FORMAT_PIPED="piped";
   static public final String RESULT_FORMAT_XML="xml";
   
   static public String CROSSREF_HOST="doi.crossref.org";
   static public int CROSSREF_PORT=80;

   static int curOption;    
   static String fileName=null;
   static String qType=METADATA_QUERY_TYPE;
   static String area="live";
   static String userName=null;
   static String password=null;
   static boolean doFuzzy=true;
   static String resultFormat=RESULT_FORMAT_PIPED;
   static String proxyHostPort=null;
   static String crossHostPort=null;
   
   static public void main (String[] args)
      throws Exception
   {
      if (args.length==0) {
         help();
         System.exit(0);
      }
      
      GetOpt getOpt = new GetOpt (args,"hf:t:a:u:p:zr:x:s:");
      
      while ((curOption=getOpt.getNextOption ())!=-1) {
         switch (curOption) {                
         case 'f':
            fileName = getOpt.getOptionArg ();
            break;
         case 't':
            qType = getOpt.getOptionArg ();
            break;
         case 'a':
            area = getOpt.getOptionArg ();
            break;
         case 'u':
            userName = getOpt.getOptionArg ();
            break;
         case 'p':
            password = getOpt.getOptionArg ();
            break;
         case 'z':
            doFuzzy=false;
            break;
         case 'r':
            resultFormat = getOpt.getOptionArg ();
            break;
         case 'x':
            proxyHostPort = getOpt.getOptionArg ();
            break;
         case 's':
            crossHostPort = getOpt.getOptionArg ();
            break;
         case 'h':
            help ();
            System.exit (0);                
         }
      }
      
      
      if (fileName==null) {
         System.out.println ("You must supply a file name");
         System.exit (-1);
      }
      
      if (!area.equalsIgnoreCase(AREA_TEST) && !area.equalsIgnoreCase(AREA_LIVE))
         throw new IllegalArgumentException ("Permitted values for area are: \"live\" or \"test\"");
      
      if (!qType.equalsIgnoreCase(METADATA_QUERY_TYPE) && !qType.equalsIgnoreCase(DOI_QUERY_TYPE))
         throw new IllegalArgumentException ("Permitted values for query type are: \"q\"(Metadata query) or \"d\"(DOI query)");
      
      if (!resultFormat.equalsIgnoreCase(RESULT_FORMAT_PIPED) && !resultFormat.equalsIgnoreCase(RESULT_FORMAT_XML))
         throw new IllegalArgumentException ("Permitted values for result format are: \"piped\" or \"xml\"");
      
      if (crossHostPort!=null) {
         int ndx=crossHostPort.indexOf (":");
         if (ndx!=-1)
            CROSSREF_HOST = crossHostPort.substring (0,ndx);
         else
            CROSSREF_HOST = crossHostPort;
         
         if (ndx!=-1 && ndx<(crossHostPort.length()-1))
            CROSSREF_PORT = Integer.parseInt(crossHostPort.substring (ndx+1));
      }
      String proxyHost=null;
      int proxyPort = 80;
      if (proxyHostPort!=null) {                        
         int ndx=proxyHostPort.indexOf (":");
         if (ndx!=-1)
            proxyHost = proxyHostPort.substring (0,ndx);
         else
            proxyHost = proxyHostPort;
         
         if (ndx!=-1 && ndx<(proxyHostPort.length()-1))
            proxyPort = Integer.parseInt(proxyHostPort.substring (ndx+1));                        
      }
      
      String qData = readFromFile (fileName);
      if (qData==null) {
         System.out.println ("File does not exist or no data in file");
         System.exit (-1);
      }
      
      HTTPResponse rsp = doQuery (qData,qType,area,userName,password,doFuzzy,resultFormat,proxyHost,proxyPort,CROSSREF_HOST,CROSSREF_PORT);
      if (rsp.getStatusCode() >= 300)
      {
         System.err.println("Received Error: "+rsp.getReasonLine());
         System.err.println(rsp.getText());
      }
      else {
         System.out.println (rsp.getText());
      }
   }
   
   static public HTTPResponse doQuery (String qData,String qType,String area,
                               String userName,String password,boolean doFuzzy,
                               String resultFormat)
      throws Exception
   {
      return doQuery (qData,qType,area,userName,password,doFuzzy,resultFormat,null,0);
   }
   
   static public HTTPResponse doQuery (String qData,String qType,String area,
                               String userName,String password,boolean doFuzzy,
                               String resultFormat,String proxyHost,int proxyPort)
      throws Exception
   {
      return doQuery (qData,qType,area,userName,password,doFuzzy,resultFormat,proxyHost,proxyPort,CROSSREF_HOST,CROSSREF_PORT);
   }
   
   static public HTTPResponse doQuery (String qData,String qType,String area,
                               String userName,String password,boolean doFuzzy,
                               String resultFormat,String proxyHost,int proxyPort,
                               String crossRefHost,int crossRefPort)
      throws Exception
   {
      String uri = "/servlet/query?type=" + qType;
      
      if (userName!=null && password!=null)
         uri += "&usr=" + userName + "&pwd=" + password;
      
      if (resultFormat!=null)
         uri+= "&format=" + resultFormat;
      
      if (!doFuzzy)
         uri+= "&fuzzy=false";
      
      uri += "&qdata=" + java.net.URLEncoder.encode (qData);

      HTTPClient.CookieModule.setCookiePolicyHandler (null);
      HTTPConnection conn = new HTTPConnection (crossRefHost,crossRefPort);
      if (proxyHost!=null)
         conn.setCurrentProxy (proxyHost,proxyPort);
      
      HTTPResponse rsp = conn.Get (uri);      
      return rsp;
   }
   
   
   
   
   /**
    * Print help information
    */
   static public void help ()
   {
      System.out.println ("Perfom a CrossRef synch. query");
      System.out.println ("Usage: java org.crossref.client.CrossRefQuery -f filename [-t queryType]  [-a area] [-u username] [-p password] [-z] [-r resultFormat] [-x proxy host:Port] [-s CrossRef host:port] [-h]");
      System.out.println ("Where:\n");
      System.out.println ("-f <fileName> File you want to submit");
      System.out.println ("-t <queryType> 'q' (Metadata query) or  'd' (DOI query). Default is 'q'");
      System.out.println ("-a <area> The area this query is intended for, must be one of two values: \"live\" or \"test\". Default value is live");
      System.out.println ("-u <username> User name assigned to you by CrossRef");
      System.out.println ("-p <password> Password assigned to you by CrossRef");
      System.out.println ("-z Do NOT perform fuzzy matching (default is to perform fuzzy matching)");
      System.out.println ("-r Result format. piped or xml (default is piped)");
      System.out.println ("-x <proxy host:port> Route the request through an HTTP proxy if needed (.e.g -x host:8080)");
      System.out.println ("-s <CrossRef host:port> override default crossref host:port (.e.g -s localhost:8080)");
      System.out.println ("-h : print this help");               
   }        
   
   static public String readFromFile(String filename)
   {
      java.io.BufferedReader in = null;
      StringBuffer content = null;
      
      if (filename == null)
         return null;
      
      try {
         in = new java.io.BufferedReader(new java.io.FileReader(filename));
         content = new StringBuffer();
         int ch;
         
         while (true) {
            ch = in.read();
            if (ch < 0)
               break;
            content.append((char)ch);
         }
         
         in.close();	
      }
      catch (java.io.IOException e) {
         return null;
      }
      
      return content.toString();
   }

}
