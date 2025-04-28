package com.youngbeen.youngService.DTO;

public class SubwayInfoDTO {
    private String subwayId;

    @Override
    public String toString() {
        return "SubwayInfo{" +
                "subwayId='" + subwayId + '\'' +
                ", statnNm='" + statnNm + '\'' +
                ", updnLine='" + updnLine + '\'' +
                ", trainLineNm='" + trainLineNm + '\'' +
                ", arvlMsg2='" + arvlMsg2 + '\'' +
                ", arvlMsg3='" + arvlMsg3 + '\'' +
                ", recptnDt='" + recptnDt + '\'' +
                ", barvlDt='" + barvlDt + '\'' +
                ", bstatnNm='" + bstatnNm + '\'' +
                ", lstcarAt='" + lstcarAt + '\'' +
                '}';
    }

    public String getSubwayId() {
        return subwayId;
    }

    public void setSubwayId(String subwayId) {
        this.subwayId = subwayId;
    }

    public String getStatnNm() {
        return statnNm;
    }

    public void setStatnNm(String statnNm) {
        this.statnNm = statnNm;
    }

    public String getUpdnLine() {
        return updnLine;
    }

    public void setUpdnLine(String updnLine) {
        this.updnLine = updnLine;
    }

    public String getTrainLineNm() {
        return trainLineNm;
    }

    public void setTrainLineNm(String trainLineNm) {
        this.trainLineNm = trainLineNm;
    }

    public String getArvlMsg2() {
        return arvlMsg2;
    }

    public void setArvlMsg2(String arvlMsg2) {
        this.arvlMsg2 = arvlMsg2;
    }

    public String getArvlMsg3() {
        return arvlMsg3;
    }

    public void setArvlMsg3(String arvlMsg3) {
        this.arvlMsg3 = arvlMsg3;
    }

    public String getRecptnDt() {
        return recptnDt;
    }

    public void setRecptnDt(String recptnDt) {
        this.recptnDt = recptnDt;
    }

    public String getBarvlDt() {
        return barvlDt;
    }

    public void setBarvlDt(String barvlDt) {
        this.barvlDt = barvlDt;
    }

    public String getBstatnNm() {
        return bstatnNm;
    }

    public void setBstatnNm(String bstatnNm) {
        this.bstatnNm = bstatnNm;
    }

    public String getLstcarAt() {
        return lstcarAt;
    }

    public void setLstcarAt(String lstcarAt) {
        this.lstcarAt = lstcarAt;
    }

    private String statnNm;
    private String updnLine;
    private String trainLineNm;
    private String arvlMsg2;
    private String arvlMsg3;
    private String recptnDt;
    private String barvlDt;
    private String bstatnNm;
    private String lstcarAt;
}