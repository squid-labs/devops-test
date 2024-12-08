package handlers

import (
    "github.com/gin-gonic/gin"
    "goapp/models"
    "net/http"
)

var users = map[string]models.User{
    "1": {
        ID:    "1",
        Name:  "John Doe",
        Email: "john@example.com",
        Age:   30,
    },
    "2": {
        ID:    "2",
        Name:  "Jane Smith",
        Email: "jane@example.com",
        Age:   25,
    },
    "3": {
        ID:    "3",
        Name:  "Bob Johnson",
        Email: "bob@example.com",
        Age:   35,
    },
}

func GetUsers(c *gin.Context) {
    userList := make([]models.User, 0)
    for _, user := range users {
        userList = append(userList, user)
    }
    c.JSON(http.StatusOK, userList)
}

func GetUser(c *gin.Context) {
    id := c.Param("id")
    if user, exists := users[id]; exists {
        c.JSON(http.StatusOK, user)
        return
    }
    c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
}

func CreateUser(c *gin.Context) {
    var user models.User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }
    users[user.ID] = user
    c.JSON(http.StatusCreated, user)
}

func UpdateUser(c *gin.Context) {
    id := c.Param("id")
    if _, exists := users[id]; !exists {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }

    var user models.User
    if err := c.ShouldBindJSON(&user); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    user.ID = id
    users[id] = user
    c.JSON(http.StatusOK, user)
}

func DeleteUser(c *gin.Context) {
    id := c.Param("id")
    if _, exists := users[id]; !exists {
        c.JSON(http.StatusNotFound, gin.H{"error": "User not found"})
        return
    }
    delete(users, id)
    c.JSON(http.StatusOK, gin.H{"message": "User deleted"})
}
