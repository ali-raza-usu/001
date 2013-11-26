package utilities.messages.ver1;

import java.io.Serializable;

import org.junit.Test;

import utilities.*;


public class WeatherDataRequest extends Message implements Serializable {

	private RequestType reqType;

	private static final long serialVersionUID = 1L;

	public WeatherDataRequest(RequestType _type) {
		this.setVersion("1.0");
		reqType = _type;
	}

	public RequestType getReqType() {
		return reqType;
	}

	public void setReqType(RequestType reqType) {
		this.reqType = reqType;
	}

	private RequestType randomType() {
		RequestType[] _type = RequestType.values();
		int val = 0 + (int) (Math.random() * 3);
		return _type[val];
	}

	@Test
	public void testRandomType() {
		int i = 0;
		while (i++ < 20) {
			System.out.println(randomType().name());
		}
	}
}
