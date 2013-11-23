package extensions;


import java.nio.ByteBuffer;
import java.nio.channels.SocketChannel;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;

public aspect VersionControlAspect {

	private static Logger _logger = Logger
			.getLogger(VersionControlAspect.class);

	private pointcut ChannelRead(SocketChannel _channel, ByteBuffer _buffer) :
		call(* SocketChannel+.read(ByteBuffer)) && target(_channel) && args(_buffer);

	int around(SocketChannel _channel, ByteBuffer _buffer) : ChannelRead(_channel, _buffer) {
		ByteBuffer tempBuf = _buffer.duplicate();

		int readBytes = proceed(_channel, _buffer);
		if (readBytes > 0) {
			Object obj = thisJoinPoint.getThis();
			if (obj instanceof Client) {
				TranslationMessage msg = (TranslationMessage) convertBufferToMessage(tempBuf);
				_logger.debug("Client received the message "+ msg.getClass()+" at time " + getCurrentTime());
				
			}
		}
		return readBytes;
	}


	
}
