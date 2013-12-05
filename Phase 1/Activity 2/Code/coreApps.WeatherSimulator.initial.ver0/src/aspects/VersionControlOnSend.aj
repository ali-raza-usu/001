package aspects;


import java.net.SocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.DatagramChannel;
import java.nio.channels.SocketChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.TimerTask;

import org.apache.log4j.Logger;

import simulation.communication.Receiver;
import simulation.communication.Transmitter_8815;

import utilities.Encoder;
import utilities.Message;
import utilities.messages.ver0.WeatherDataRequest;
import utilities.messages.ver0.WeatherDataVector;
import utilities.messages.ver0.WeatherDataVector.ObservationType;
import utilities.messages.ver1.WeatherDataReading;
import utilities.messages.ver1.WeatherDataVector.LocType;

public aspect VersionControlOnSend {

	Logger _logger = Logger.getLogger(VersionControlOnSend.class);

	private pointcut ChannelWrite(DatagramChannel _channel, ByteBuffer _buffer, SocketAddress adr) :
			call(* DatagramChannel+.send(ByteBuffer,SocketAddress)) && target(_channel) && args(_buffer, adr);

	int around(DatagramChannel _channel, ByteBuffer _buffer , SocketAddress _adr) : ChannelWrite(_channel, _buffer, _adr){
				
		 Message msg = convertBufferToMessage(_buffer);
		 if(msg!=null)
		 {
		_logger.debug("Data in the buffer " + _buffer.remaining());
		Object obj = thisJoinPoint.getThis();
		if (obj instanceof Receiver) {
			
			String msgName = msg.getClass().getSimpleName();
			if(msgName.equals(WeatherDataRequest.class.getSimpleName()))
			{
			 utilities.messages.ver1.WeatherDataRequest req = (utilities.messages.ver1.WeatherDataRequest)msg;
			 utilities.messages.ver0.WeatherDataRequest request=new WeatherDataRequest();
			 msg  = request;
			}
			
		}		
		else if(obj instanceof Transmitter_8815){
			String msgName = msg.getClass().getSimpleName();
			if(msgName.equals(WeatherDataVector.class.getSimpleName()))
			{
			 utilities.messages.ver0.WeatherDataVector wdv = (utilities.messages.ver0.WeatherDataVector)msg;
			 List<utilities.messages.ver0.WeatherDataReading> _readings=wdv.getReadings();
			 List<utilities.messages.ver1.WeatherDataReading> _readings_v1=new  ArrayList<WeatherDataReading>();
			 for(utilities.messages.ver0.WeatherDataReading wdr: _readings)
			 {
				LocType loctype=utilities.messages.ver1.WeatherDataVector.LocType.values()[wdr.getFacilityLocType().ordinal()];
				utilities.messages.ver1.WeatherDataVector.ObservationType obstype=utilities.messages.ver1.WeatherDataVector.ObservationType.values()[wdr.getFacilityLocType().ordinal()];
				
				 utilities.messages.ver1.WeatherDataReading reading=new  utilities.messages.ver1.WeatherDataReading(wdr.getSpeed(), wdr.getWindDirection(), wdr.getHumidity(), wdr.getPrecipitation(), loctype, wdr.getPressure(), wdr.getCloudHeight(), wdr.getVisibility(), wdr.getSolarRadiations(), wdr.getSnowDepth(), obstype, wdr.getTemperature(), wdr.getSendTime(), wdr.getSize(), wdr.getResolution());
				 _readings_v1.add(reading);
			 }
			 utilities.messages.ver1.WeatherDataVector request=new utilities.messages.ver1.WeatherDataVector(_readings_v1);
			 msg  = request;
			}
			
	    }
		else
		{
			String msgName = msg.getClass().getSimpleName();
			if(msgName.equals(WeatherDataRequest.class.getSimpleName()))
			{
			 utilities.messages.ver1.WeatherDataRequest req = (utilities.messages.ver1.WeatherDataRequest)msg;
			 utilities.messages.ver0.WeatherDataRequest request=new WeatherDataRequest();
			 msg  = request;
			}
		}
		_buffer = ByteBuffer.wrap(Encoder.encode(msg));
	 }
		 return proceed(_channel, _buffer, _adr);
   }

	private Message convertBufferToMessage(ByteBuffer buffer) {
		Message message = null;
		byte[] bytes = new byte[buffer.remaining()];
		buffer.get(bytes);
		message = Encoder.decode(bytes);
		buffer.clear();
		buffer = ByteBuffer.wrap(Encoder.encode(message));
		return message;
	}
	
	
}
