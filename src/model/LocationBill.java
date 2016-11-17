package model;

import java.sql.Date;

public class LocationBill {
	private Date date;
	private int maxDuration;
	private float hourlyPrice;
	private float deposit;

	public LocationBill(Date date,int maxDuration,float hourlyPrice,float deposit){
		this.date = date;
		this.maxDuration = maxDuration;
		this.hourlyPrice = hourlyPrice;
		this.deposit = deposit;
	}

	public LocationBill(){
		;
	}

	public Date getDate(){
		return this.date;
	}

	public int getMaxDuration(){
		return this.maxDuration;
	}

	public float getHourlyPrice(){
		return this.hourlyPrice;
	}

	public float getDeposit(){
		return this.deposit;
	}

	public void setDate(Date date){
		this.date = date;
	}

	public void setMaxDuration(int maxDuration){
		this.maxDuration = maxDuration;
	}

	public void setHourlyPrice(float hourlyPrice){
		this.hourlyPrice = hourlyPrice;
	}

	public void setDeposit(float deposit){
		this.deposit = deposit;
	}

	@Override
	public String toString(){
		return "Date: "+this.date+" MaxDuration: "+this.maxDuration+" HourlyPrice: "+this.hourlyPrice+" Deposit: "+this.deposit;
	}

}
