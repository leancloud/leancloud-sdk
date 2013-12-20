package com.example.avoscloud_demo;

import com.avos.avoscloud.AVObject;
import com.avos.avoscloud.AVUser;

public class SubUser extends AVUser {
    public AVObject getArmor() {
        return getAVObject("armor");
    }

    public void setArmor(AVObject armor) {
        this.put("armor", armor);
    }

    public void setNickName(String name) {
        this.put("nickName", name);
    }

    public String getNickName() {
        return this.getString("nickName");
    }
}
