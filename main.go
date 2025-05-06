
package main

import (
	"fmt"
	"net/http"
)

var (
	version    string
	commitHash string
)

func main() {
	// Print version and commit hash to the console
	fmt.Printf("Hello, World!\nVersion: %s\nCommit Hash: %s\n", version, commitHash)

	// Define a simple HTTP handler
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, k8 using scratch\nVersion: %s\nCommit Hash: %s\n", version, commitHash)
	})

	// Start the HTTP server
	fmt.Println("Server is running at http://localhost:8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		fmt.Printf("Error starting server: %s\n", err)
	}
}