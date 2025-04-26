package com.d0iloppa.spring5.template.model;

/**
 * @author doil
 * @date 25. 4. 20.
 */
public class AdminVO {

    int lgn_no;
    String lgn_id;
    String lgn_passwd;

    String lgn_email;
    int auth_lvl;


    public int getLgn_no() {
        return lgn_no;
    }

    public void setLgn_no(int lgn_no) {
        this.lgn_no = lgn_no;
    }

    public String getLgn_id() {
        return lgn_id;
    }

    public void setLgn_id(String lgn_id) {
        this.lgn_id = lgn_id;
    }

    public String getLgn_passwd() {
        return lgn_passwd;
    }

    public void setLgn_passwd(String lgn_passwd) {
        this.lgn_passwd = lgn_passwd;
    }

    public String getLgn_email() {
        return lgn_email;
    }

    public void setLgn_email(String lgn_email) {
        this.lgn_email = lgn_email;
    }

    public int getAuth_lvl() {
        return auth_lvl;
    }

    public void setAuth_lvl(int auth_lvl) {
        this.auth_lvl = auth_lvl;
    }
}
