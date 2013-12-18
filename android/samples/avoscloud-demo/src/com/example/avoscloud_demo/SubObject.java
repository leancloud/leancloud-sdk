package com.example.avoscloud_demo;

import com.avos.avoscloud.AVClassName;
import com.avos.avoscloud.AVObject;

/**
 * Created with IntelliJ IDEA.
 * User: zhuzeng
 * Date: 12/18/13
 * Time: 12:08 PM
 * To change this template use File | Settings | File Templates.
 */
@AVClassName("Armor")
public class SubObject extends AVObject {
    public String getDisplayName() {
        return getString("displayName");
    }

    public void setDisplayName(String value) {
        put("displayName", value);
    }

    public int getDurability() {
        return getInt("durability");
    }

    public void setBroken(boolean broken) {
        this.put("broken", broken);
    }

    public void takeDamage(int amount) {
        // Decrease the armor's durability and determine whether it has broken
        increment("durability", -amount);
        if (getDurability() < 0) {
            setBroken(true);
        }
    }
}
