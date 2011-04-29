package org.crossref.client;

import HTTPClient.*;
import java.io.File;

/**
 * A sample submission uploader. This class illustrates how to upload Asynchronous submissions to CrossRef as
 * explained in CrossRef's user documentation.(http://doi.crossref.org/doc/userdoc.html)
 * 
 * @author Hisham Shahtout - Atypon Systems (http://www.atypon.com) (hisham@atypon.com)
 * @version 1.0
 */
public class SubmissionUploader
{
    static public String CROSSREF_HOST="doi.crossref.org";
    static public int CROSSREF_PORT=80;
    
    static int curOption;
    static String fileName=null;
    // note that username and password are optional. A user might be interested in submitting
    // asynch. query submissions only and be identified through an IP.
    static String userName=null;
    static String password=null;
    static String area=null;
    static String submissionType=null;
    static String opName;
    static String proxyHostPort=null;
    static String crossHostPort=null;
    
    static public void main (String[] args)
        throws Exception
    {
        if (args.length==0) {
            help();
            System.exit(0);
        }
        
        GetOpt getOpt = new GetOpt (args,"hf:a:u:p:t:x:s:");
        
        while ((curOption=getOpt.getNextOption ())!=-1) {
            switch (curOption) {                
            case 'f':
                fileName = getOpt.getOptionArg ();
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
            case 't':
                submissionType = getOpt.getOptionArg ();
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
        
        String operation = getOperation (submissionType);
        if (operation==null) {
            System.out.println ("Illegal submission type, possible values are: M (Metadata), X (XML schema), Q (Metadata Query), D (DOI Query)");
            System.exit (-1);
        }
        
        if (fileName==null) {
            System.out.println ("You must supply a file name");
            System.exit (-1);
        }
        
        if (area==null)
            area="test";
        
        if (!area.equalsIgnoreCase("test") && !area.equalsIgnoreCase("live"))
            throw new IllegalArgumentException ("Permitted values for area are: \"live\" or \"test\" only");
        
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
        
        uploadSubmission (fileName,operation,userName,password,area,proxyHost,proxyPort,CROSSREF_HOST,CROSSREF_PORT);        
    }
    
    /**
     * Upload a submission to the crossref system.
     * 
     * @param fileName The file to upload
     * @param operation The operation on the server to invoke depending on the file type you are uploading. "doMDUpload" for DTD metadata upload,
     * "doXSDMDUpload" for XML schema metadata files. "doQueryUpload" for Asynch. metadata query upload and "doDOIQueryUpload" for Asynch. DOI query upload.
     * @param userName CrossRef assigned userName (pass null if authenticating through IP)
     * @param password CrossRef assigned password (pass null if authenticating through IP)
     * @param area "live" or "test"
     * 
     * @exception if an error occured while posting the request or if CrossRef rejected the request (invalid login/password for example)
     */
    static public void uploadSubmission (String fileName,String operation,
                                         String userName,String password,String area)
        throws Exception
    {
        uploadSubmission (fileName,operation,userName,password,area,null,0);
    }
    
    /**
     * Same as above but route the request through a proxy
     */
    static public void uploadSubmission (String fileName,String operation,
                                         String userName,String password,String area,
                                         String proxyHost,int proxyPort)
        throws Exception
    {
        uploadSubmission (fileName,operation,userName,password,area,proxyHost,proxyPort,CROSSREF_HOST,CROSSREF_PORT);
    }
    
    /**
     * Same as above but submit the request to a site different than the default (doi.crossref.org:80)
     */
    static public void uploadSubmission (String fileName,String operation,
                                         String userName,String password, String area,
                                         String proxyHost,int proxyPort,String crossRefHost,int crossRefPort)
        throws Exception
    {        
        File inFile = new File (fileName);
        if (inFile.isDirectory ())
            throw new Exception (fileName + " is a folder, not a file");
        
        NVPair[] uploadFileOpts = new NVPair[1];
        uploadFileOpts[0] = new NVPair ("fname",inFile.getAbsolutePath());            
        NVPair[] ct_hdr = new NVPair[1];
        
        byte[] uploadBytes = Codecs.mpFormDataEncode ( null,uploadFileOpts,ct_hdr);                
        CookieModule.setCookiePolicyHandler(null);
        HTTPConnection httpConn = new HTTPConnection (crossRefHost,crossRefPort);
        if (proxyHost!=null)
            httpConn.setCurrentProxy (proxyHost,proxyPort);
        
        String url = "/servlet/deposit?operation=" + operation;
        if (userName!=null && password!=null)
            url += "&login_id=" + userName + "&login_passwd=" + password;
        
        url+="&area=" + area;                
        
        HTTPResponse httpResp = httpConn.Post (url,uploadBytes,ct_hdr);
        
        if (httpResp.getStatusCode() >= 300)
            throw new Exception (httpResp.getText());
        else
        {
            String responseText = httpResp.getText();
            if (responseText.toLowerCase().indexOf ("success")!=-1)
                return; // everything went fine
            
            int ndx1 = responseText.indexOf ("<p>")+3;
            int ndx2 = responseText.indexOf ("</p>");
            if (ndx1!=-1 && ndx2!=-1 && ndx2>ndx1)
                throw new Exception (responseText.substring (ndx1,ndx2)); // extract error message
            else
                throw new Exception (responseText);
        }                        
    }
    
        
    /**
     * Maps the submissionType to the operation name required by the server ("M" for example is mapped to doMDUpload).
     *  See CrossRef's system interface documentation online for more information.
     */
    static public String getOperation (String submissionType)
    {
        if (submissionType==null || submissionType.equalsIgnoreCase("M"))
            return "doMDUpload";
                
        if (submissionType.equalsIgnoreCase ("Q"))
            return "doQueryUpload";
        
        if (submissionType.equalsIgnoreCase ("D"))
            return "doDOIQueryUpload";
        
        return null;
    }
    
    
    /**
     * Print help information
     */
    static public void help ()
    {
        System.out.println ("CrossRef Asynch. submission upload sample.");
        System.out.println ("Usage: java org.crossref.client.SubmissionUpload -f filename [-t submissionType]  [-a area] [-u username] [-p password] [-x proxy host:Port] [-s CrossRef host:port] [-h]");
        System.out.println ("Where:\n");
        System.out.println ("-f <fileName> File you want to submit");
        System.out.println ("-t <submissionType> M | Q | D (Metadata | Metadata Query | DOI Query respectively) Default is M");
        System.out.println ("-a <area> The area for this submission, must be one of two values: \"live\" or \"test\". Default value is test");
        System.out.println ("-u <username> User name assigned to you by CrossRef");
        System.out.println ("-p <password> Password assigned to you by CrossRef");
        System.out.println ("-x <proxy host:port> Route the request through an HTTP proxy if needed (.e.g -x host:8080)");
        System.out.println ("-s <CrossRef host:port> override default crossref host:port (.e.g -s localhost:8080)");
        System.out.println ("-h : print this help");               
    }    
}
