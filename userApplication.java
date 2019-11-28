
//ΣΤΑΥΡΟΣ ΑΝΤΩΝΙΑΔΗΣ ΑΕΜ:8279
import java.net.*;
import java.io.*;
import javax.sound.sampled.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class UserApplication
{

public static void main(String[] args) throws IOException , LineUnavailableException
	{
		//echo();
		//image();
		sound();
	}



//########################################### Echo Packets ##########################################################
	static void echo() throws IOException
	{
	//############################### Echo Packets with delay ##########################################


	 	String echo_request_code="E1132"; // for packets with delay look at ithaki netlab fot this code
	 	String echo_request_code_wihout_delay="E0000"; // if you want packets without server delay
	 	String echo_request_code_temp=""; // for packets with temperature
	 	String packet_infos= null;

	 	long start_time=0; 
		long this_time=0;
		long send_time=0;
		long receive_time=0;

	 	DatagramSocket send_socket = new DatagramSocket(); // i create socket for send function
	 	byte[] txbuffer= echo_request_code.getBytes();
	 	int server_port= 38028; // look at ithaki netlab for this port
	 	byte[] server_IP= {(byte)155,(byte)207,(byte)18,(byte)208}; // standard IP address for server // ithaki
	 	InetAddress server_Address= InetAddress.getByAddress(server_IP);
	 	DatagramPacket send_packet = new DatagramPacket(txbuffer,txbuffer.length,server_Address,server_port);

	 	int client_port= 48028; // look at ithaki netlab for this port
	 	DatagramSocket receive_socket = new DatagramSocket(client_port);
	 	byte[] rxbuffer= new byte[54];
	 	receive_socket.setSoTimeout(3500);
	 	DatagramPacket receive_packet = new DatagramPacket(rxbuffer,rxbuffer.length);

	 	File file1 = new File("C:/Users/stan1/Desktop/Packet_time.txt");
	 	FileOutputStream packet_time = new FileOutputStream(file1);

	 	File file2 = new File("C:/Users/stan1/Desktop/Packet_infos.txt");
	 	FileOutputStream packet_info = new FileOutputStream(file2);

	 	int no_packets=0;
	 	start_time= System.currentTimeMillis();
	 	this_time= start_time;

	 	while((this_time-start_time)<=240000){ // we want packets for 4 minutes
	 		
	 		send_time= System.currentTimeMillis();
	 		send_socket.send(send_packet);
	 		try{
	 			receive_socket.receive(receive_packet);
	 			receive_time= System.currentTimeMillis();
	 			packet_infos= new String(rxbuffer,0,receive_packet.getLength());

	 		} catch(Exception x){
	 			System.out.println(x);
	 		}

	 		no_packets++;
	 		long elapsed_time= receive_time-send_time; // time between send and receive functions
	 		String elapsed= Long.toString(elapsed_time); // convert long type variable into String so as i can write it to file
	 		elapsed = "Packet No" + (no_packets)+":" + elapsed_time + "ms" + System.lineSeparator();
	 		byte[] insert = elapsed.getBytes(); // write function write to file only bytes so we need to type casting variable to byte
	 		packet_time.write(insert);

	 		packet_infos= packet_infos + System.lineSeparator();
	 		byte[] insert_infos=packet_infos.getBytes();
	 		packet_info.write(insert_infos);
	 		this_time= System.currentTimeMillis();
	 	}


	 // ############################### Echo Packets without delay ############################################

	 	start_time=0; // we make the viarables 0 so as we can recount the elapsed time
	 	this_time=0;
	 	send_time=0;
	 	receive_time=0;

	 
	 	txbuffer=echo_request_code_wihout_delay.getBytes();
	 	send_packet.setData(txbuffer);
	 	send_packet.setLength(txbuffer.length);

	 	File file3 = new File("C:/Users/stan1/Desktop/Packet_time_wd.txt");
	 	FileOutputStream packet_time_wd = new FileOutputStream(file3);

	 	File file4 = new File("C:/Users/stan1/Desktop/Packet_infos_wd");
	 	FileOutputStream packet_infos_wd = new FileOutputStream(file4);

	 	no_packets=0;
	 	start_time= System.currentTimeMillis();
	 	this_time= start_time;

	 	while(this_time-start_time <=240000){ // we want packets for 4 minutes
	 		
	 		send_time= System.currentTimeMillis();
	 		send_socket.send(send_packet);
	 		try{
	 			receive_socket.receive(receive_packet);
	 			receive_time= System.currentTimeMillis();
	 			packet_infos= new String(rxbuffer,0,receive_packet.getLength());

	 		} catch(Exception x){
	 			System.out.println(x);
	 		}

	 		no_packets++;
	 		long elapsed_time= receive_time-send_time; // time between send and receive functions
	 		String elapsed= Long.toString(elapsed_time); // convert long type variable into String so as i can write it to file
	 		elapsed = "Packet No" + (no_packets) + ":"+ elapsed_time + "ms" + System.lineSeparator();
	 		byte[] insert = elapsed.getBytes(); // write function write to file only bytes so we need to type casting variable to byte
	 		packet_time_wd.write(insert);

	 		packet_infos= packet_infos +System.lineSeparator();
	 		byte[] insert_infos=packet_infos.getBytes();
	 		packet_infos_wd.write(insert_infos);
	 		this_time= System.currentTimeMillis();
	 	}

	//################################# Echo Packets with Temperature #########################################
		File file5 = new File("C:/Users/stan1/Desktop/Packet_infos_temp.txt");
		FileOutputStream packet_infos_temp = new FileOutputStream(file5);

		

		for(int i=0; i<100; i++){
			if(i<10) echo_request_code_temp= echo_request_code + "T" + "0" + String.valueOf(i);
			else echo_request_code_temp= echo_request_code + "T"+ String.valueOf(i);

			txbuffer = echo_request_code_temp.getBytes();
			send_packet.setData(txbuffer);
			send_packet.setLength(txbuffer.length);

			send_socket.send(send_packet);

			try
			{
				receive_socket.receive(receive_packet);
				packet_infos = new String(rxbuffer,0,receive_packet.getLength());
				

			} catch (Exception x) 
				{    
		     		 System.out.println(x); 
				} 
			packet_infos=packet_infos + System.lineSeparator();
			byte[] insert_infos = packet_infos.getBytes();  // Finally is byte type 
			packet_infos_temp.write(insert_infos); 

		}
		receive_socket.close();
		send_socket.close();
	}	 	

	//############################################ Images #########################################################

	static void image() throws IOException
	{
		String image_request_code = "M1256";

		File file6 = new File("C:/Users/stan1/Desktop/imageFIX.jpeg");
		FileOutputStream image = new FileOutputStream(file6);

		DatagramSocket send_socket = new DatagramSocket(); 
		byte[] txbuffer = image_request_code.getBytes();
		int serverPort=38028; // look at ithaki netlab for code
		byte[] hostIP = {(byte)155,(byte)207,18,(byte)208};
		InetAddress hostAddress = InetAddress.getByAddress(hostIP);
		DatagramPacket send_packet = new DatagramPacket(txbuffer,txbuffer.length,hostAddress,serverPort);


		int clientPort=48028; // look at ithaki netlab for code
		DatagramSocket receive_socket = new DatagramSocket(clientPort);
		receive_socket.setSoTimeout(3500);  										
		byte[] rxbuffer = new byte[130];							
		DatagramPacket receive_packet = new DatagramPacket(rxbuffer,rxbuffer.length);

		send_socket.send(send_packet);
		for (;;) 
		{
			try 
			{
				receive_socket.receive(receive_packet);

				byte[] data = new byte[receive_packet.getLength()];
				System.arraycopy(receive_packet.getData(), receive_packet.getOffset(), data, 0, receive_packet.getLength());

				image.write(data);

			} catch (Exception x) 
			{
				System.out.println(x);
				break;
			}
		}

		//########################################## Image with CAM=PTZ ##########################################################

		image_request_code = "M1256CAM=PTZ";

		File file7 = new File("C:/Users/stan1/Desktop/imagePTZ.jpeg");
		FileOutputStream image2 = new FileOutputStream(file7);

		
		txbuffer = image_request_code.getBytes();
		send_packet.setData(txbuffer);
		send_packet.setLength(txbuffer.length);

		send_socket.send(send_packet);
		for (;;) 
		{
			try 
			{
				receive_socket.receive(receive_packet);

				byte[] data = new byte[receive_packet.getLength()];
				System.arraycopy(receive_packet.getData(), receive_packet.getOffset(), data, 0, receive_packet.getLength());

				image2.write(data);
			} catch (Exception x) 
				{
					System.out.println(x);
					break;
				}
		}

		send_socket.close();
		receive_socket.close();
	}


	//############################################ Sound ####################################################################

	static void sound() throws IOException , LineUnavailableException
	{
		int type = 1 ; // 1 for DPCM , 2 for AQ-DPCM

		String sound_request_code = "A2696F500"; // put AQ after code for AQ-DPCM
		int server_port = 38028;
		int client_port= 48028; 
		int number_of_packets = 999; // we need 999 packets for 31.2 sec of audio , because we want a value near 30 sec 
		int number_of_bpp=0; 


		if(type == 1)
		{
			number_of_bpp=128;	// bytes per packet ** 128 for DPCM ** 
		}
		else if(type == 2)
		{
			number_of_bpp=132;	// bytes per packet ** 132 for AQ-DPCM ** 
		}

		byte[] audioreceived = new byte[number_of_bpp*number_of_packets]; // all the audio bytes that i received

		DatagramSocket send_socket = new DatagramSocket(); // initialize socket for send
		byte[] txbuffer = sound_request_code.getBytes();
		byte[] server_IP = {(byte)155,(byte)207,18,(byte)208};
		InetAddress server_Address = InetAddress.getByAddress(server_IP);
		DatagramPacket send_packet = new DatagramPacket(txbuffer,txbuffer.length,server_Address,server_port); // initialize packet for send

									
		DatagramSocket receive_socket = new DatagramSocket(client_port); // initialize socket for receive 
		receive_socket.setSoTimeout(3500);  	// we set timeout for how long we will wait to receive a packet									
		byte[] rxbuffer = new byte[number_of_bpp];	               							
		DatagramPacket receive_packet = new DatagramPacket(rxbuffer,rxbuffer.length);// initialize socket for receive

		send_socket.send(send_packet);

		int n=0; // number of packets 

		for (;;) 
		{
			try 
			{
				receive_socket.receive(receive_packet);
				for( int i=0 ; i<number_of_bpp ; i++)
				{
					audioreceived[n*number_of_bpp+i] = rxbuffer[i]; //save the bytes from audio
				}
				n++;
			} catch (Exception x) 
			  {
				System.out.println(x);
				break;
			  }
		} 



		//#################################### DECODE ##################################################################

 

		int[] diffs = new int[256*number_of_packets]; // here i will save the differences -- is 256 because a singel byte have 2 differences of audio
													  // it is 256 in both types

		byte[] song = new byte[256*number_of_packets]; // here i will save the clear audio



		if(type == 1) //DPCM ------- m=0 , b=1
		{
			File file1 = new File("C:/Users/stan1/Desktop/DPCM/DPCM_DIFFERENCES.txt");
			FileOutputStream differs = new FileOutputStream(file1);


			File file2 = new File("C:/Users/stan1/Desktop/DPCM/DPCM_SAMPLES.txt");
			FileOutputStream song_samples = new FileOutputStream(file2);


			AudioFormat linearPCM = new AudioFormat(8000,8,1,true,false);
			SourceDataLine lineOut = AudioSystem.getSourceDataLine(linearPCM);
			lineOut.open(linearPCM,number_of_bpp*number_of_packets*2);


			for(int i=0 ; i<number_of_bpp*number_of_packets ; i++)
			{
				int k = (int)audioreceived[i]; // one byte each time, i could use the audioreceived[i] itself but i have to make an logical shift
				diffs[2*i+1] = ((k & 15) - 8);  //1,3,5,...
				k = k >>> 4 ; //logical shift by 4 to get the other difference. i dont care about the upper bits because of &, like before . Logical shift is because i dont care about sign
				diffs[2*i] = ((k & 15) - 8);   //0,2,4,6,...
			}

			song[0] = (byte)(2*diffs[0]);
			for(int i=1 ; i<128*number_of_packets ; i++)
			{
				song[i] =(byte)(2*diffs[i] + song[i-1]);
			}

			
			for(int i=0 ; i<128*number_of_packets ; i++)
			{
				int temp = song[i];	
				String temp2 = String.valueOf(temp);
				temp2 = temp2 + System.lineSeparator();
				song_samples.write(temp2.getBytes());
				temp = diffs[i];
				temp2 = String.valueOf(temp);
				temp2 = temp2 + System.lineSeparator();
				differs.write(temp2.getBytes());		
			}

			lineOut.start();
			lineOut.write(song,0,song.length);
			
			
			lineOut.stop();
			lineOut.close();
			send_socket.close();
			receive_socket.close();
			
		}

		if(type == 2) // AQ-DPCM
		{

			File file3 = new File("C:/Users/stan1/Desktop/AQ/AQ_DIFFERENCES.txt");
			FileOutputStream differs_aq = new FileOutputStream(file3);

			File file4 = new File("C:/Users/stan1/Desktop/AQ/AQ_SAMPLES.txt");
			FileOutputStream song_samples_aq = new FileOutputStream(file4);

			File file5 = new File("C:/Users/stan1/Desktop/AQ/AQ_MEANS.txt");
			FileOutputStream mean = new FileOutputStream(file5);

			File file6 = new File("C:/Users/stan1/Desktop/AQ/AQ_STEPS.txt");
			FileOutputStream step = new FileOutputStream(file6);

			int means[] = new int[number_of_packets]; // mean of 256 samples , so 128 bytes
			int steps[] = new int[number_of_packets]; // same

			AudioFormat linearPCM = new AudioFormat(8000,16,1,true,false);
			SourceDataLine lineOut = AudioSystem.getSourceDataLine(linearPCM);
			lineOut.open(linearPCM,number_of_bpp*number_of_packets*2);


			for(int i=0 ; i<number_of_packets ; i++) // i will take the steps and the means because i need them for the second step 
			{
				int lsb = audioreceived[number_of_bpp*i]  ; //lsb bytes
				int msb = audioreceived[number_of_bpp*i + 1]; // msb
				means[i] = ((msb << 8 ) + (lsb)); 
				String string = Integer.toString(means[i]) + System.lineSeparator();
				mean.write(string.getBytes());
				lsb = audioreceived[number_of_bpp*i + 2] ;
				msb = audioreceived[number_of_bpp*i + 3] ;
				steps[i] = ((lsb)+ ((msb) << 8));
				string = Integer.toString(steps[i]) + System.lineSeparator();
				step.write(string.getBytes());
			}


			n=0;

			for(int i=0 ; i<number_of_packets ; i++)
			{
				for(int j=4 ; j<number_of_bpp ; j++)
				{
					int k = (int)audioreceived[i*132 + j]; 
					diffs[2*n+1] = ((k & 15) - 8) * steps[i];  //1,3,5,...
					k = k >>> 4 ; //logical shift by 4 to get the other difference. i dont care about the upper bits because of &, like before . Logical shift is because i dont care about sign
					diffs[2*n] = ((k & 15) - 8) * steps[i];   //0,2,4,6,...
					n++;
				}
			}


			for(int i=0 ; i<number_of_packets ; i++)
			{
				for(int j=0 ; j<256 ; j++)
				{
					String string = Integer.toString(diffs[i*256 + j]) + System.lineSeparator();
					differs_aq.write(string.getBytes());
					if( i==0 && j==0 ) continue;
					diffs[i*256 + j] = diffs[i*256 + j] + diffs[i*256 + j -1];

				}
			}


			byte[] song2 = new byte[512*number_of_packets];
			int counter = -1;
			for (int i=0 ; i<number_of_packets ; i++)
			{	
				for(int j=0 ; j<256 ; j++)
				{
					diffs[i*256 + j] += means[i];
					String string = Integer.toString(diffs[i*256 + j]) + System.lineSeparator();
					song_samples_aq.write(string.getBytes());
					song2[++counter] = (byte)  diffs[i*256 + j];
					song2[++counter] = (byte)  (diffs[i*256 + j]>> 8) ;
				}

			}



			lineOut.start();
			lineOut.write(song2,0,song2.length);
			
			
			lineOut.stop();
			lineOut.close();
			send_socket.close();
			receive_socket.close();	
			
		}

	}
}