package application;

public class Controller {

	public static void main(String[] args) {
		try {
			Transmitter transmitter1 = new Transmitter(8815);
			transmitter1.start();
			Thread.sleep(1500);
			Transmitter transmitter2 = new Transmitter(8816);
			transmitter2.start();
			Thread.sleep(1500);
			Receiver receiver = new Receiver(8815, 8816);
			receiver.start();
		} catch (Exception e) {
		}
	}
}
