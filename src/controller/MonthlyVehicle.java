package controller;

import java.sql.Date;

public class MonthlyVehicle {
	private String date;
	private int vehicleId;
	private float averageTime;
	

	/** Constructor of MonthlyVehicle 
	 *  @param date Considered month
	 *  @param vehicleId Id of the vehicle
	 *  @param averageTime Average usage time
	 **/
	public MonthlyVehicle(String date,int vehicleId,float averageTime){

		this.date = date;
		this.vehicleId = vehicleId;
		this.averageTime = averageTime;
	}

	/** Emptry constructor of MonthlyVehicle */
	public MonthlyVehicle(){
		;
	}

	/** @param date Set date of MonthlyVehicle */
	public void setDate(String date) {
		this.date = date;
	}

	/** @return date */
	public String getDate() {
		return date;
	}

	/** @param vehicleId Set vehicleId of MonthlyVehicle */
	public void setVehicleId(int vehicleId) {
		this.vehicleId = vehicleId;
	}

	/** @return vehicleId */
	public int getVehicleId() {
		return vehicleId;
	}

	/** @param averageTime Set averageTime of MonthlyVehicle */
	public void setAverageTime(float averageTime) {
		this.averageTime = averageTime;
	}

	/** @return averageTime */
	public float getAverageTime() {
		return averageTime;
	}

	/** @return String with values of every field */
	@Override
	public String toString(){
		return "Date: "+this.date+" VehicleId: "+this.vehicleId+" Average time: "+this.averageTime;
	}
}
