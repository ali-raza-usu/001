package utilities.messages.ver1;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import utilities.Message;

public class WeatherDataVector extends Message implements Serializable {

	private static final long serialVersionUID = 1L;
	private Date msgLog = new Date();

	public static enum LocType {
		LAND, SEA;
	}

	public static enum ObservationType {
		MANUAL, AUTOMATIC;
	}

	private List<WeatherDataReading> _readings = new ArrayList<WeatherDataReading>();

	public WeatherDataVector(List<WeatherDataReading> _readings) {
		this._readings = _readings;
		//this.setVersion("1.0");
	}

	public WeatherDataVector() {
		//this.setVersion("1.0");
	}

	public List<WeatherDataReading> getReadings() {
		return _readings;
	}

	public void setReadings(List<WeatherDataReading> _readings) {
		this._readings = _readings;
	}

	public Date getMsgLog() {
		return msgLog;
	}

	public void setMsgLog(Date msgLog) {
		this.msgLog = msgLog;
	}

	@Override
	public String toString() {
		return msgLog.toString();
	}
}
