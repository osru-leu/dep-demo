package main

import (
	"fmt"
	// "net/http"
)

var (
	version string
	commitHash string
	runNumber string
)

func main() {
	fmt.Printf("Hello, World!\nVersion: %s\nCommit Hash: %s\n Run Number: %s\n", version, commitHash, runNumber)
}
// func main() {
// 	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
// 		fmt.Fprintf(w, "Hello, k8 using scratch")
// 	})
// 	http.ListenAndServe(":8080", nil)
// }