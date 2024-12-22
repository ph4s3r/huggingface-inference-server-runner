##########################################################################################################
# Author: Peter Karacsonyi                                                                               #
# Last updated: 2024 dec 22                                                                              #
# Runner script for HuggingFace Embedding Inference Server                                               #
# Main github project site: https://github.com/huggingface/text-embeddings-inference                     #
# API endpoints: https://huggingface.github.io/text-embeddings-inference/                                #
# Tags: https://github.com/huggingface/text-embeddings-inference/pkgs/container/text-embeddings-inference#
##########################################################################################################


$model = "dunzhang/stella_en_1.5B_v5"
Set-Location C:\dev\tei\
$volume = "$pwd\models\"
$prompt_name = "s2p_query"
# either we use the default_prompt of the name
# $default_prompt = "Instruct: Given a web search query, retrieve relevant passages that answer the query.\nQuery: "
$docker_container_name = "huggingface-embeddings-inference"
$containerport = 3000 # the huggingface server inside listens on this port
$localport = 3001
$image = "ghcr.io/huggingface/text-embeddings-inference:cuda-1.6"

# Check if anything is already listening on local port
if (Get-NetTCPConnection -LocalPort $localport -ErrorAction SilentlyContinue) {
    Write-Host "Error: Port $localport is already in use. Please stop the process using this port and try again." -ForegroundColor Red
    exit 1
}

# Run the Docker container
docker run --gpus all -p ${localport}:$containerport -v "${volume}:/data" --name $docker_container_name $image `
    --model-id $model --default-prompt-name $prompt_name --port $containerport
