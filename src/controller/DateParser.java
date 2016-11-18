package controller;

import java.util.Date;
import java.text.SimpleDateFormat;
import java.text.ParseException;

public class DateParser {
	private Date currentDate;
	private SimpleDateFormat format;
	

	/** Constructor of DateParser
	 *  @param currentDate Current date
	 *  @param format Date format
	 **/
	public DateParser(Date currentDate,SimpleDateFormat format){
		this.currentDate = currentDate;
		this.format = format;
	}

	/** Initialize current date to the one of the virtual machine and format is "YYYY-MM-DD" */
	public DateParser(){
		this.currentDate = new Date();
		this.format = new SimpleDateFormat("YYYY-MM-DD");
	}

	/** @param currentDate Set currentDate of DateParser */
	public void setCurrentDate(Date currentDate) {
		this.currentDate = currentDate;
	}

	/** @return currentDate */
	public Date getCurrentDate() {
		return currentDate;
	}

	/** @return current date to SQL format */
	public java.sql.Date getSQLCurrentDate() {
		return new java.sql.Date(currentDate.getTime());
	}

	/** @param format Set format of DateParser */
	public void setFormat(SimpleDateFormat format) {
		this.format = format;
	}

	/** @return format */
	public SimpleDateFormat getFormat() {
		return format;
	}

	public java.sql.Date getSQLDate(String date){
		try {
			if(format == null)
				System.out.println("WTF");
			return new java.sql.Date(format.parse(date).getTime());
		} catch(ParseException e){
			return null;
		}
	}
}
