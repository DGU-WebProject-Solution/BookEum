package dao.bean;

public class Userbean {
    private String id;
    private String pw;
    private String name;
    private String birth;
    private String addressCity;
    private String addressGu;
    private String starRate;
    private String emailId;

    // 기본 생성자
    public Userbean() {}

    // 매개변수를 받는 생성자
    public Userbean(String id, String pw, String name, String birth, String addressCity, String addressGu, String starRate, String emailId) {
        this.id = id;
        this.pw = pw;
        this.name = name;
        this.birth = birth;
        this.addressCity = addressCity;
        this.addressGu = addressGu;
        this.starRate = starRate;
        this.emailId = emailId;
    }

    // ID getter & setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    // Password getter & setter
    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }
    
    // Name getter & setter
    public String getName() {
    	return name;
    }
    
    public void setName(String name) {
    	this.name = name;
    }

    // Birthdate getter & setter
    public String getBirth() {
        return birth;
    }

    public void setBirth(String birth) {
        this.birth = birth;
    }

    // Address City getter & setter
    public String getAddressCity() {
        return addressCity;
    }

    public void setAddressCity(String addressCity) {
        this.addressCity = addressCity;
    }

    // Address Gu getter & setter
    public String getAddressGu() {
        return addressGu;
    }

    public void setAddressGu(String addressGu) {
        this.addressGu = addressGu;
    }
    
    // StarRate getter & setter
    public String getStarRate() {
    	return starRate;
    }
    
    public void setStarRate(String starRate) {
    	this.starRate = starRate;
    }

    // Email Id getter & setter
    public String getEmailId() {
        return emailId;
    }

    public void setEmailId(String emailId) {
        this.emailId = emailId;
    }
}
