package utilities.messages.ver0;

import java.util.UUID;

import org.junit.Test;

import utilities.Message;

public class WeatherDataRequest extends Message {

	

	private static final long serialVersionUID = 1L;
	private UUID requestId = UUID.randomUUID();

	public WeatherDataRequest() {
		this.setVersion("0.0");
	}

	
	@Test
	public void testRandomType() {
		int i = 0;
		//while (i++ < 20) {
			//System.out.println(randomType().name());
		//}
	}

	public UUID getRequestId() {
		return requestId;
	}

	public void setRequestId(UUID requestId) {
		this.requestId = requestId;
	}

}
