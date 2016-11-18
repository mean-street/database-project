package controller;

public class DailyStation {
	private String stationName;
	private float occupancyRate;
	

	/** Constructor of DailyStation
	 *  @param stationName Name of considered station
	 *  @param occupancyRate Rate of occupancy
	 **/
	public DailyStation(String stationName,float occupancyRate){
		this.stationName = stationName;
		this.occupancyRate = occupancyRate;
	}

	/** Empty constructor */
	public DailyStation(){
		;
	}

	/** @param stationName Set stationName of DailyStation */
	public void setStationName(String stationName) {
		this.stationName = stationName;
	}

	/** @return stationName */
	public String getStationName() {
		return stationName;
	}

	/** @param occupancyRate Set occupancyRate of DailyStation */
	public void setOccupancyRate(float occupancyRate) {
		this.occupancyRate = occupancyRate;
	}

	/** @return occupancyRate */
	public float getOccupancyRate() {
		return occupancyRate;
	}

	/** @return DaylyStation as data string */
	@Override
	public String toString(){
		return "Station name: "+this.stationName+" Occupancy rate: "+this.occupancyRate;
	}
}
