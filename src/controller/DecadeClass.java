public class DecadeClass {
	private String className;
	private float usageTime;
	

	/** Constructor of DecadeClass 
	 *  @param className Name of considered class
	 *  @param usageTime Average usage time of specified vehicle class
	 **/
	public DecadeClass(String className,float usageTime){
		this.className = className;
		this.usageTime = usageTime;
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

	/** @param usageTime Set usageTime of DecadeClass */
	public void setUsageTime(float usageTime) {
		this.usageTime = usageTime;
	}

	/** @return usageTime */
	public float getUsageTime() {
		return usageTime;
	}

	/** @return Decade class as a data string */
	@Override
	public String toString(){
		return "Class name: "+this.className+" Usage time: "+this.usageTime;
	}
}
