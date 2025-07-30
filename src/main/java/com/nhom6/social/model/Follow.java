package com.nhom6.social.model;

public class Follow {
    private int followingUserId;
    private int followedUserId;
    private String createdAt;

    public Follow() {}
    public Follow(int followingUserId, int followedUserId, String createdAt) {
        this.followingUserId = followingUserId;
        this.followedUserId = followedUserId;
        this.createdAt = createdAt;
    }
    public int getFollowingUserId() { return followingUserId; }
    public void setFollowingUserId(int followingUserId) { this.followingUserId = followingUserId; }
    public int getFollowedUserId() { return followedUserId; }
    public void setFollowedUserId(int followedUserId) { this.followedUserId = followedUserId; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}