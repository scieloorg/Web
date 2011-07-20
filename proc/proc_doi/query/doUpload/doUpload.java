import HTTPClient.*;
import java.net.*;
import java.io.*;
import java.util.*;

public class doUpload
{
  static String option ="DEPOSIT";
  static String proxyHost="";
  static int proxyPort = 80;
  static String host="doi.crossref.org";
  static int port= 80;

  public static void sendPOST(String XMLFile, String username, String password)
  throws Exception 
  
  {
    System.out.println("Posting to http://"+ host + ":" + port);

    System.out.println("Sending: " + XMLFile);
    HTTPClient.NVPair[] uploadOpts = new HTTPClient.NVPair[2];
    HTTPClient.NVPair[] uploadFileOpts = new HTTPClient.NVPair[1];  

    if (option.equals("DEPOSIT")) option="doMDUpload";
    if (option.equals("DEPOSIT_REFS")) option="doDOICitUpload";
    if (option.equals("QUERY")) option="doQueryUpload";
    if (option.equals("DOIQUERY")) option="doDOIQueryUpload";
         
    uploadOpts[0] = new HTTPClient.NVPair ("operation",option);
    uploadOpts[1] = new HTTPClient.NVPair ("area","live"); // live | test

    uploadFileOpts[0] = new HTTPClient.NVPair ("fname",XMLFile);

    HTTPClient.NVPair[] ct_hdr = new HTTPClient.NVPair[1];

    byte[] uploadBytes;
 
    HTTPClient.HTTPConnection httpConn = new HTTPClient.HTTPConnection (host,port);

    if (proxyHost.length()>0)
    {
        System.out.println("Using proxy at: "  + proxyHost + ":" + proxyPort);
        httpConn.setCurrentProxy(proxyHost, proxyPort);
    }

    uploadBytes = HTTPClient.Codecs.mpFormDataEncode (uploadOpts,uploadFileOpts,ct_hdr);
    HTTPClient.CookieModule.setCookiePolicyHandler(null); 
    HTTPClient.HTTPResponse httpResp = null;

    httpResp = httpConn.Post ("/servlet/deposit?login_id=" + username + "&login_passwd=" + password,uploadBytes,ct_hdr); 
   
    System.out.println("httpResp status is "+ httpResp.getStatusCode());
    System.out.println(httpResp.getText());

    httpConn.stop();
  }

  public static void main(String[] args) 
  {

    try
    {

      if (args.length <= 0)
      {
        System.out.println("");
        System.out.println("Usage: java -jar \"doUpload.jar\" -u username -p password -f file-name <-o upload-option>");
        System.out.println("This program uploads files to the CrossRef system");
        System.out.println("If the given file has a '.list' extension it is considered");
        System.out.println("to be a file with a list of files to upload.\n");
        System.out.println("Any other extension is considered a single file upload.");
        System.out.println("If the file is a directory then all files in the directory will be uploaded.\n");
        System.out.println("The default upload option is DEPOSIT, alternatively it can be set to DEPOSIT_REFS, QUERY or DOIQUERY");
        System.out.println("Other optional args:  -h host -hp port -ph proxy host -pp proxy port");
        System.out.println("        -h defaults to doi.crossref.org");
        System.out.println("        -hp defaults to port 80");
        System.out.println("        -ph name of a proxy host if  needed");
        System.out.println("        -pp proxy port");

        return;
      }
      String username = "";
      String password = "";
      String filename = "";

      for (int i=0; i<args.length; i++)
      {
        if (args[i].equals("-u"))
            {username=args[i+1];}
        if (args[i].equals("-p"))
            {password=args[i+1];}
        if (args[i].equals("-f"))
            {filename=args[i+1];}
        if (args[i].equals("-h"))
            {host=args[i+1];}
        if (args[i].equals("-o"))
            {option=args[i+1];}
        if (args[i].equals("-hp"))
            {port = new Integer(args[i+1]).intValue();}
        if (args[i].equals("-ph"))
            {proxyHost=args[i+1];}
        if (args[i].equals("-pp"))
            {proxyPort = new Integer(args[i+1]).intValue();}
        i++;
      }
      
 
      String           lineRead = null;

//   ================================================

     File inFile = new File(filename);

     if (filename.indexOf(".list") >= 0) //=== it is a ist of files
     {
//       pubDir.close();
//       FileInputStream pipeFile = new FileInputStream(filename);
//       DataInputStream inData   = new DataInputStream(pipeFile);

       BufferedReader  inData   = new BufferedReader(new FileReader(filename));
       do
       {
         lineRead = inData.readLine();
         if (lineRead != null)  sendPOST(lineRead, username, password);
       }
       while(lineRead != null);
     }
     else if (inFile.isDirectory())
     {
       File fList[] = inFile.listFiles();
       for (int i=0; i<fList.length; i++)
           sendPOST(fList[i].getPath(), username, password);

     }
     else
     {
       sendPOST(filename, username, password);
     }
  
    }
    catch (Exception e) 
    {
      System.out.println(e.toString());
      System.err.println(e.getMessage());
      e.printStackTrace();
    }
  }
} 
