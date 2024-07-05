#!/bin/bash

# Target URL and output file prefix
URL="http://172.16.16.101:33333"
OUTPUT_PREFIX="thread"

# Array of thread values
THREAD_VALUES=(10 50 100 150 200)

# Number of connections
CONNECTIONS=1000

# Function to extract metrics from wrk output and append to the file
extract_and_append_metrics() {
    local file=$1
    local threads=$2

    failed_requests=$(grep 'Socket errors:' $file | awk '{print $4}')
    total_transfer=$(grep 'Transfer/sec:' $file | awk '{print $2, $3}')
    requests_per_second=$(grep 'Requests/sec:' $file | awk '{print $2}')
    latency=$(grep 'Latency' $file | awk '{print $2}')
    transfer_rate=$(grep 'Transfer/sec:' $file | awk '{print $2, $3}')

    {
        echo "Threads: $threads"
        echo "Failed Requests: $failed_requests"
        echo "Total Transfer: $total_transfer"
        echo "Requests per Second: $requests_per_second"
        echo "Latency: $latency"
        echo "Transfer Rate: $transfer_rate"
        echo "-----------------------------"
    } >> $file
}

# Run wrk with different thread values
for t in "${THREAD_VALUES[@]}"; do
    OUTPUT_FILE="${t}_${OUTPUT_PREFIX}.txt"
    echo "Running wrk with ${t} threads..."
    
    # Run wrk and capture the output
    wrk -c $CONNECTIONS -t $t $URL > $OUTPUT_FILE
    
    # Extract and append metrics
    extract_and_append_metrics $OUTPUT_FILE $t
    
    echo "Output written to ${OUTPUT_FILE}"
done

echo "All tests completed."

