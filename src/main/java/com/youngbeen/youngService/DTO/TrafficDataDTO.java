package com.youngbeen.youngService.DTO;

public class TrafficDataDTO {
    private Long id;
    private String exDivName;
    private String regionName;
    private String inoutName;
    private String tcsName;

    @Override
    public String toString() {
        return "TrafficDataDTO{" +
                "tcsName='" + tcsName + '\'' +
                ", regionName='" + regionName + '\'' +
                ", trafficAmount=" + trafficAmount +
                ", sumTm='" + sumTm + '\'' +
                ", carType=" + carType +
                '}';
    }

    private Integer trafficAmount;

    private String sumTm;
    private String openClName;
    private Integer carType;
    private String exDivCode;
    private Integer inoutType;
    private Integer openClType;
    private String regionCode;
    private Integer tcsType;
    private Integer tmType;
    private String tmName;
    private String code;
    private String message;
    private Integer count;

    public String getExDivName() {
        return exDivName;
    }

    public void setExDivName(String exDivName) {
        this.exDivName = exDivName;
    }

    public String getRegionName() {
        return regionName;
    }

    public void setRegionName(String regionName) {
        this.regionName = regionName;
    }

    public String getInoutName() {
        return inoutName;
    }

    public void setInoutName(String inoutName) {
        this.inoutName = inoutName;
    }

    public String getTcsName() {
        return tcsName;
    }

    public void setTcsName(String tcsName) {
        this.tcsName = tcsName;
    }

    public Integer getTrafficAmount() {
        return trafficAmount;
    }

    public void setTrafficAmount(Integer trafficAmount) {
        this.trafficAmount = trafficAmount;
    }

    public String getSumTm() {
        return sumTm;
    }

    public void setSumTm(String sumTm) {
        this.sumTm = sumTm;
    }

    public String getOpenClName() {
        return openClName;
    }

    public void setOpenClName(String openClName) {
        this.openClName = openClName;
    }

    public Integer getCarType() {
        return carType;
    }

    public void setCarType(Integer carType) {
        this.carType = carType;
    }

    public String getExDivCode() {
        return exDivCode;
    }

    public void setExDivCode(String exDivCode) {
        this.exDivCode = exDivCode;
    }

    public Integer getInoutType() {
        return inoutType;
    }

    public void setInoutType(Integer inoutType) {
        this.inoutType = inoutType;
    }

    public Integer getOpenClType() {
        return openClType;
    }

    public void setOpenClType(Integer openClType) {
        this.openClType = openClType;
    }

    public String getRegionCode() {
        return regionCode;
    }

    public void setRegionCode(String regionCode) {
        this.regionCode = regionCode;
    }

    public Integer getTcsType() {
        return tcsType;
    }

    public void setTcsType(Integer tcsType) {
        this.tcsType = tcsType;
    }

    public Integer getTmType() {
        return tmType;
    }

    public void setTmType(Integer tmType) {
        this.tmType = tmType;
    }

    public String getTmName() {
        return tmName;
    }

    public void setTmName(String tmName) {
        this.tmName = tmName;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }


}
