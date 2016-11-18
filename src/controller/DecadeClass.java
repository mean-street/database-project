package controller;

public class DecadeClass {
	private String className;
	private float averageTime;
	

	/** Constructor of DecadeClass 
	 *  @param className Name of considered class
	 *  @param averageTime Average usage time of specified vehicle class
	 **/
	public DecadeClass(String className,float averageTime){
		this.className = className;
		this.averageTime = averageTime;
	}

	/** Emptry constructor of DecadeClass */
	public DecadeClass(){
		;
	}

	/** @param className Set className of DecadeClass */
	public void setClassName(String className) {
		this.className = className;
	}

	/** @return className */
	public String getClassName() {
		return className;
	}

	/** @param averageTime Set averageTime of DecadeClass */
	public void setAverageTime(float averageTime) {
		this.averageTime = averageTime;
	}

	/** @return averageTime */
	public float getAverageTime() {
		return averageTime;
	}

	/** @return Decade class as a data string */
	@Override
	public String toString(){
		return "Class name: "+this.className+" Usage time: "+this.averageTime;
	}
}
