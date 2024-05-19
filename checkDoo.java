import java.net.*;
import java.io.*;

public class checkDoo{
    public static void main(String[] args) throws Exception {
        String httpUrl = args[0];
        URL url2call = new URL(httpUrl);
		try{
			HttpURLConnection conn = (HttpURLConnection) url2call.openConnection();
			int responseCode = conn.getResponseCode();

			if(responseCode == 200 ) //HTTP 200: Response OK
			{
                System.out.println("OK");
			}
			else
			{ 
				System.out.println("KO");
			}
        }catch (IOException e) { System.out.println("KO");}
}
}

