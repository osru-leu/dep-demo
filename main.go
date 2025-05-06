package main

import (
	"fmt"
	"net/http"
	"os"
)

var (
	version    string
	commitHash string
)

func main() {
	// Print version and commit hash to the console
	fmt.Printf("Hello, World!\nVersion: %s\nCommit Hash: %s\n", version, commitHash)

	// Check if running in a CI environment
	if os.Getenv("CI") != "true" {
		// Define a simple HTTP handler
		http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			fmt.Fprintf(w, "Hello, k8 using scratch\nVersion: %s\nCommit Hash: %s\n", version, commitHash)
		})

		// Start the HTTP server
		fmt.Println("Server is running at http://localhost:8080")
		if err := http.ListenAndServe(":8080", nil); err != nil {
			fmt.Printf("Error starting server: %s\n", err)
		}
	} else {
		fmt.Println("Running in CI environment, server not started.")
	}
}
