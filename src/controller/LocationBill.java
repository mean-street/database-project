package controller;

import java.sql.Date;

public class LocationBill {
	private Date date;
	private int maxDuration;
	private float hourlyPrice;
	private float deposit;
	

	/** Constructor of LocationBill
	 *  @param date Date of location
	 *  @param maxDuration Maximum amount of time of location
	 *  @param hourlyPrice Hourly price of the location
	 *  @param deposit Deposit of the location
	 **/
	public LocationBill(Date date,int maxDuration,float hourlyPrice,float deposit){
		this.date = date;
		this.maxDuration = maxDuration;
		this.hourlyPrice = hourlyPrice;
		this.deposit = deposit;
	}

	public LocationBill(){
		;
	}

	/** @param date Set date of LocationBill */
	public void setDate(Date date) {
		this.date = date;
	}

	/** @return date */
	public Date getDate() {
		return date;
	}

	/** @param maxDuration Set maxDuration of LocationBill */
	public void setMaxDuration(int maxDuration) {
		this.maxDuration = maxDuration;
	}

	/** @return maxDuration */
	public int getMaxDuration() {
		return maxDuration;
	}

	/** @param hourlyPrice Set hourlyPrice of LocationBill */
	public void setHourlyPrice(float hourlyPrice) {
		this.hourlyPrice = hourlyPrice;
	}

	/** @return hourlyPrice */
	public float getHourlyPrice() {
		return hourlyPrice;
	}

	/** @param deposit Set deposit of LocationBill */
	public void setDeposit(float deposit) {
		this.deposit = deposit;
	}

	/** @return deposit */
	public float getDeposit() {
		return deposit;
	}

	/** @return LocationBill as a String */
	public String toString(){
		return "Date: "+this.date+" Max duration: "+this.maxDuration+" Hourly price: "+this.hourlyPrice+" Deposit: "+this.deposit;
	}
}
