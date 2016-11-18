package controller;

public class LocationBill {
	private int idVehicle;
	private String className;
	private float price;
	

	/** Constructor of LocationBill
	 *  @param idVehicle Id of considered vehicle
	 *  @param className Class name of considered vehicle
	 *  @param price Total price of location
	 **/
	public LocationBill(int idVehicle,String className,float price){
		this.idVehicle = idVehicle;
		this.className = className;
		this.price = price;
	}

	/** Empty constructor of LocationBill */
	public LocationBill(){
		;
	}

	/** @param idVehicle Set idVehicle of LocationBill */
	public void setIdVehicle(int idVehicle) {
		this.idVehicle = idVehicle;
	}

	/** @return idVehicle */
	public int getIdVehicle() {
		return idVehicle;
	}

	/** @param className Set className of LocationBill */
	public void setClassName(String className) {
		this.className = className;
	}

	/** @return className */
	public String getClassName() {
		return className;
	}

	/** @param price Set price of LocationBill */
	public void setPrice(float price) {
		this.price = price;
	}

	/** @return price */
	public float getPrice() {
		return price;
	}

	/** @return Location as a data string */
	@Override
	public String toString(){
		return "Id of vehicle: "+this.idVehicle+" Class name: "+this.className+" Price: "+this.price;
	}
}
